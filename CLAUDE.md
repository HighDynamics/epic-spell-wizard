# Epic Spell Wizard

Elm 0.19.1 single-page app. `src/Main.elm` is the entry point; `index.html`
holds the JS glue (ports, localStorage, service worker registration) and
`sw.js` is the service worker. Deployed to GitHub Pages by
`.github/workflows/deploy.yml`.

## Checks

Run `npm run check` before committing; CI runs the same five checks as
separate jobs (see `README.md` and `docs/ci-quality.md`).

- Elm code must be elm-format 0.8.8 clean (`npm run format`). Keep formatting-only
  changes in their own commit.
- elm-review rules are in `review/src/ReviewConfig.elm`. Don't silence a rule
  wholesale; disable it narrowly and say why in the config.
- Tools are pinned to Elm 0.19.1-compatible versions (`elm@0.19.1-6`,
  `elm-test@0.19.1-revision17`). Don't let `npm update` move them to 0.19.3
  without also moving the app and the deploy workflow.
- Adding a seed or global factor also needs its code in the `UrlState` tables;
  `tests/UrlStateTest.elm` fails if it is missing.
