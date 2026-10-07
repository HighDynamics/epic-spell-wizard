const js = require('@eslint/js');
const globals = require('globals');
const html = require('eslint-plugin-html');

module.exports = [
    { ignores: ['node_modules/**', 'dist/**', 'elm-stuff/**', 'review/**', 'elm.js'] },
    js.configs.recommended,
    {
        // Service worker.
        files: ['sw.js'],
        languageOptions: {
            sourceType: 'script',
            globals: { ...globals.serviceworker },
        },
    },
    {
        // Inline <script> blocks in index.html (Elm bootstrap, ports, SW registration).
        // `Elm` comes from elm.js and `tailwind` from the Tailwind CDN script.
        files: ['index.html'],
        plugins: { html },
        languageOptions: {
            sourceType: 'script',
            globals: { ...globals.browser, Elm: 'readonly', tailwind: 'writable' },
        },
    },
    {
        files: ['eslint.config.js'],
        languageOptions: {
            sourceType: 'commonjs',
            globals: { ...globals.node },
        },
    },
];
