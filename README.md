# Live shopping

Basic Live shopping was developed with Vue for the frontend and Agoston for the backend.

- [Demo](https://live-shopping-ui.agoston.io)
- [node package](https://www.npmjs.com/package/@agoston-io/client)
- [Data model](./src/data-model/live_shopping.sql)

## Features

- Authentication with user/password
- Create channels
- Create broadcasts per channel
- Showcase products
- Chat per broadcast
- Fast and responsive (even with millions of broadcasters)

## Install

1. Go to [Agoston](https://agoston.io) and create a free account.
2. In the pgAdmin console execute the SQL script in [src/data-model/live_shopping.sql](src/data-model/live_shopping.sql).
3. Adujst the environment variables in `src/.env` to fit your Agoston environment:

```env
VUE_APP_AGOSTON_BACKEND_URL='<AGOSTON_BACKEND_URL>'
```

4. Run the frontend

```sh
cd src
# For Node >= 17: https://candid.technology/error-error-0308010c-digital-envelope-routines-unsupported/
export NODE_OPTIONS=--openssl-legacy-provider
npm run serve
```

## License

MIT
