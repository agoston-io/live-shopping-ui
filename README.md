# Live Shopping UI

Live Shopping UI ([Demo](https://live-shopping-ui.agoston.io/))
with backend from [Agoston](https://agoston.io/).

## Features

- Authentication with Google or user/password
- Create unlimited channels
- Create unlimited broadcasts per channel
- Showcase unlimited products
- Infinite scroll of broadcast on mobile
- Chat on broadcast
- Very fast and responsive even with millions of broadcasts

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
# https://candid.technology/error-error-0308010c-digital-envelope-routines-unsupported/
export NODE_OPTIONS=--openssl-legacy-provider
npm run serve
```

**NOTE:** Refer to the Agoston [quick start](https://docs.agoston.io/quickstart) for step by step tutorial.

## License

MIT
