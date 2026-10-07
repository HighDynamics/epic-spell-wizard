# CI quality checks

Researched and added 2026-10-07. This is the reasoning behind the checks in
`.github/workflows/ci.yml`; the commands to run them are in the README.

## What the repo is built with

- **Elm 0.19.1** single-page app (`src/Main.elm` plus `Calc`, `Seeds`,
  `Factors`, `UrlState`, `Export`, `Types`, `View/*`; about 4.3k lines).
  Only `elm/*` core packages, no third-party Elm dependencies.
- **Plain JavaScript** only at the edges: `sw.js` (service worker) and the
  inline `<script>` blocks in `index.html` (Elm bootstrap, ports, service
  worker registration, Tailwind CDN config). No bundler, no JS build step.
- **Deploy**: `.github/workflows/deploy.yml` compiles with
  `elm make --optimize` and publishes to GitHub Pages on push to main. It is
  unchanged.
- Before this work there were no tests, no linting and no CI on pull requests.
  `elm-format` was an npm dependency but nothing enforced it, and 8 of the 16
  Elm files were not formatted.

A note on versions: Elm **0.19.3** was released on 2026-10-02, and the "latest"
npm tags of `elm-test` and `elm-review init` now assume it. The app is on
0.19.1 and the deploy pins 0.19.1, so every tool here is pinned to a
0.19.1-compatible release (`elm@0.19.1-6`, `elm-test@0.19.1-revision17`).
Moving to 0.19.3 is a separate decision for Daniel, not part of this change.

## Candidates and decisions

### Formatting

| Candidate | Decision |
| --- | --- |
| **elm-format 0.8.8** | **Chosen.** The community-standard formatter, no options to argue about, and already an npm dependency of the repo. `--validate` makes it a check. Pinned in `package-lock.json`. |
| Prettier (for JS) | Rejected. The JS is about 100 lines; ESLint already covers the problems that matter. |

### Linting / static analysis

| Candidate | Decision |
| --- | --- |
| **elm-review** with `elm-review-unused`, `elm-review-simplify`, `elm-review-common` | **Chosen.** The standard Elm linter. Catches dead code, redundant expressions and premature `let` computation that the compiler accepts. Rules live in `review/src/ReviewConfig.elm`. |
| **ESLint 10** (flat config, `@eslint/js` recommended) plus `eslint-plugin-html` | **Chosen** for `sw.js` and the inline scripts in `index.html`. The recommended set only reports likely mistakes, not style. `eslint-plugin-html` is needed because the app logic (clipboard and URL ports, localStorage) lives in `index.html`. |
| elm-analyse | Rejected. Unmaintained and overlaps elm-review. |
| elm-review `NoExposingEverything`, `NoImportingEverything` | Rejected. `Types.elm` and the `Types exposing (..)` imports are a deliberate style in this codebase. |
| elm-review `NoMissingTypeExpose` | Rejected. It guards package APIs; this is an application. |
| TypeScript / `tsc --checkJs` | Rejected. Disproportionate for about 100 lines of JS. |

### Type checking

The Elm compiler is the type checker. CI runs `elm make --optimize`, the same
command the deploy uses, on every PR, so a PR that cannot be deployed fails
before merge (`npm run build`, output discarded).

### Tests

| Candidate | Decision |
| --- | --- |
| **elm-test** (`elm-test@0.19.1-revision17`, `elm-explorations/test` 2.2.1) | **Chosen.** The standard runner. A small suite on the pure logic where bugs would hurt: the DC maths in `Calc`, the share-link encoder/decoder in `UrlState` (every seed and every global factor must survive an encode/decode round trip, which catches a seed or factor added without a URL code), and uniqueness/lookup invariants on the seed and factor data. |
| elm-test-rs | Rejected. Faster, but it is another tool for a 16-test suite. |
| elm-program-test / browser tests (Playwright) | Rejected for now. Useful later if the UI grows, but heavy for a personal project. |

### Security / dependency audit

- Runtime dependencies: only `elm/*` core packages. No npm package ships to
  users (the site is `elm.js` plus static files), so there is nothing for an
  audit to gate in production.
- `npm audit` currently reports 4 **high** findings, all one advisory
  (`braces` ReDoS, GHSA-vfj7-8cjw-p6xm) reached through
  `chokidar` from `elm-review` and `elm-test`. It is in the dev-only file
  watcher, never ships to users, and no patched `braces` version exists, so
  an `npm audit` gate would be permanently red. **Not gated in CI.** Worth
  re-checking when `elm-review` or `elm-test` update `chokidar`.
- Tailwind is loaded from the CDN in `index.html` without a subresource
  integrity hash. That is inherent to the Tailwind Play CDN (it generates CSS
  at runtime) and is left alone; moving to a built stylesheet would change the
  deploy and is out of scope.
- A secret scanner (gitleaks) was considered and rejected: the repo has no
  secrets, no backend and only the default `GITHUB_TOKEN`.

## What CI runs

`.github/workflows/ci.yml` runs on `pull_request` and on `push` to `main`, with
read-only permissions and no secrets. Actions are pinned to commit SHAs. npm
and the Elm package cache (`~/.elm`) are cached. Each check is its own job so a
failure points at one thing and each can be a required status check:

| Job (check name) | Command |
| --- | --- |
| `Elm format` | `npm run format:check` |
| `Elm review` | `npm run review` |
| `Elm tests` | `npm test` |
| `Elm build` | `npm run build` |
| `JS lint` | `npm run lint:js` |

`npm run check` runs all of them locally in one go.

## Findings on first run

- **elm-format**: 8 files unformatted. Fixed in a formatting-only commit.
- **elm-review**: 14 errors in 6 files, all fixed with no behaviour change.
  - 10 `NoPrematureLetComputation`: `let` values computed on paths that never use
    them, moved into the branch that uses them (Elm is pure, so there is no
    observable change).
  - 4 dead-code findings: 2 unused `Dict` imports, 1 unused export (`Calc.targetToAreaText`),
    1 ignored `_` parameter (`viewFactorsPanel` was passed a `DcBreakdown` it
    never read; the parameter and the call site were dropped).
  - 2 unused constructors, `Component.F` and `Component.XP`. Not removed: the
    type mirrors the complete spell component list and Export/Calc already
    handle them. This one rule is disabled for `src/Types.elm` only, with the
    reason in `ReviewConfig.elm`.
- **ESLint**: 2 empty `catch (e) {}` blocks around `localStorage` in
  `index.html`, each reported twice (4 messages). Intentional (private
  browsing, blocked storage), so they now use `catch {}` with a comment saying
  why.
- **elm-test**: 16 tests, all passing; no bugs found.
