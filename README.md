# Epic Spell Wizard

An Elm 0.19.1 app for building epic spells (D&D 3.5 SRD seeds and factors),
deployed to GitHub Pages from `main`.

## Development

Needs Node 20+ (the Elm compiler and every other tool is installed from npm
and pinned in `package-lock.json`).

```sh
npm ci                  # install tools
npx elm make src/Main.elm --output=elm.js   # build for local use; open index.html
```

## Quality checks

CI (`.github/workflows/ci.yml`) runs all of these on every pull request and on
push to `main`. Run them locally before pushing:

| Command | What it does |
| --- | --- |
| `npm run check` | Everything below, in order |
| `npm run format:check` | elm-format validation (`npm run format` fixes) |
| `npm run review` | elm-review (`npx elm-review --fix` fixes some) |
| `npm test` | elm-test suite in `tests/` |
| `npm run build` | `elm make --optimize`, as the deploy does |
| `npm run lint:js` | ESLint on `sw.js` and the scripts in `index.html` |

Why these tools, and what was rejected: [docs/ci-quality.md](docs/ci-quality.md).

## License

Seed content derived from the SRD is used under the Open Game License; see
[OGL.txt](OGL.txt).
