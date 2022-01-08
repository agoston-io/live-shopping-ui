import { createApp, h } from 'vue'
import './index.scss'
import apolloProvider from './apollo'
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

createApp({
    apollo: {},
    render: () => h(App),
})
    .use(apolloProvider)
    .use(VueReCaptcha, { siteKey: process.env.VUE_APP_RECAPTCHA_SITE_KEY })
    .use(VueSocialSharing)
    .component("font-awesome-icon", FontAwesomeIcon)
    .mount('#app');

