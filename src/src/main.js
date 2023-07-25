import { createApp, h } from 'vue'
import './index.scss'
import { AgostonClient } from '@agoston-io/client';
import App from './App.vue'
import { VueReCaptcha } from "vue-recaptcha-v3";
// Boostrap
import "bootstrap"
// Fontawesome
import { library } from "@fortawesome/fontawesome-svg-core";
import { faTwitter, faLinkedin, faFacebook, faGithub } from "@fortawesome/free-brands-svg-icons";
import { faThumbsUp, faAngleDoubleRight, faPhotoVideo, faSpinner } from "@fortawesome/free-solid-svg-icons";
import { faPaperPlane } from "@fortawesome/free-regular-svg-icons";
library.add(faTwitter, faLinkedin, faFacebook, faGithub, faThumbsUp, faAngleDoubleRight, faPhotoVideo, faSpinner, faPaperPlane);
import { FontAwesomeIcon } from "@fortawesome/vue-fontawesome";
// Sharing
import VueSocialSharing from 'vue-social-sharing';


AgostonClient({
    backendUrl: process.env.VUE_APP_AGOSTON_BACKEND_URL
}).then(agostonClient => {

    const apolloProvider = agostonClient.createEmbeddedApolloProvider();

    const app = createApp({
        apollo: {},
        render: () => h(App),
    })
    app.config.globalProperties.$agostonClient = agostonClient
    app.use(apolloProvider)
    app.use(VueReCaptcha, { siteKey: process.env.VUE_APP_RECAPTCHA_SITE_KEY })
    app.use(VueSocialSharing)
    app.component("font-awesome-icon", FontAwesomeIcon)
    app.mount('#app');
});

