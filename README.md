# Tells

Tells is a simple experiment. It lets people post sentences inspired by a starting word; each sentence becomes part of a virtual, infinite [exquisite corpse](http://en.wikipedia.org/wiki/Exquisite_corpse) text.

Drag sideways over the text to read it back, starting from the newest sentence. Then continue the story from its last word.

## How it runs

Tells runs on Cloudflare Workers:

- `public/` holds the page, styles and script, served as static assets.
- `src/worker.js` answers the JSON API (`GET /tells`, `GET /tells/:id`, `POST /tells`, `GET /last.json`).
- Tells are stored in a D1 database named `tells`; the schema is in `migrations/`.

The original 2012–2013 Rails 3.2 version (OpenShift + MySQL) is in the git history before this port.

## Develop

```sh
npm install
npm run dev      # applies migrations to a local D1 and starts wrangler dev
npm test
```

## Deploy

```sh
npm run deploy   # applies migrations to the remote D1, then wrangler deploy
```

[![Creative Commons License](http://i.creativecommons.org/l/by-nc-sa/3.0/80x15.png)](http://creativecommons.org/licenses/by-nc-sa/3.0/)
This work is licensed under a [Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License](http://creativecommons.org/licenses/by-nc-sa/3.0/).
