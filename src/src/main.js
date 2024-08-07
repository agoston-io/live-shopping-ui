// The Vue framework
import { createApp, h } from 'vue'
import router from './router'
import App from './App.vue'
// The Agoston client
import { AgostonClient } from '@agoston-io/client';
// Boostrap for the responsive style
import "bootstrap"
// Style with SCSS
import './index.scss'
// Fontawesome for nice Icons
import { library } from "@fortawesome/fontawesome-svg-core";
import { faTwitter, faLinkedin, faFacebook, faGithub } from "@fortawesome/free-brands-svg-icons";
import { faThumbsUp, faAngleDoubleRight, faPhotoVideo, faSpinner } from "@fortawesome/free-solid-svg-icons";
import { faPaperPlane } from "@fortawesome/free-regular-svg-icons";
library.add(faTwitter, faLinkedin, faFacebook, faGithub, faThumbsUp, faAngleDoubleRight, faPhotoVideo, faSpinner, faPaperPlane);
import { FontAwesomeIcon } from "@fortawesome/vue-fontawesome";
import { createApolloProvider } from '@vue/apollo-option'

// First creating the Agoston client with the backend URL from Agoston.
AgostonClient({
    backendUrl: process.env.VUE_APP_AGOSTON_BACKEND_URL
}).then(agostonClient => {

    const apolloClient = agostonClient.createEmbeddedApolloClient();
    const apolloProvider = createApolloProvider({
        defaultClient: apolloClient,
    })

    // Then create the Vue app with the Agoston backend configuration.
    const app = createApp({
        apollo: {},
        render: () => h(App),
    })
    app.config.globalProperties.$agostonClient = agostonClient
    /* apolloProvider: We use below the embedded Apollo client that comes with the Agoston client.
       But you could provide your own Apollo provider for advanced configuration. */
    app.use(apolloProvider)
    app.component("font-awesome-icon", FontAwesomeIcon)
    app.use(router)
    app.mount('#app');
});

