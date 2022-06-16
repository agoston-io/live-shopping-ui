# Live Shopping UI

Live Shopping UI ([Demo](https://live-shopping-ui.agoston.io/))
with backend from [Agoston](https://agoston.io/).

## Features

- Create unlimited channels
- Create unlimited broadcasts per channel
- Showcase unlimited products
- Infinite scroll of broadcast on mobile
- Chat on broadcast
- Very fast and responsive even with millions of broadcasts

## Missing

- Authentication
- Interface with a live streaming provider (e.g. Amazon IVS)

## Install

1. Go to [Agoston](https://agoston.io) and create a free account.
2. In the pgAdmin console execute the SQL script in [src/data-model/live_shopping.sql](src/data-model/live_shopping.sql).
3. Adujst the environment variables in `src/.env` to fit your environment:

```env
BASE_URL='<YOUR_FRONTEND_URL>'
VUE_APP_BACKEND_GRAPHQL_URI='<BACKEND_GRAPHQL_URI>'
VUE_APP_BACKEND_GRAPHQL_SUBSCRIPTION_URI='<BACKEND_GRAPHQL_WEBSOCKET _URI>''
VUE_APP_RECAPTCHA_SITE_KEY= # For the chat feature
```

4. Run the frontend

```sh
cd src/.env
npm run serve
```


**NOTE:** Refer to the Agoston [quick start](https://docs.agoston.io/quickstart) for step by step tutorial.

## License

MIT
