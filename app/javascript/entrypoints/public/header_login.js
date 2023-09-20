import App from '@components/header-login/App.vue';
import { generateApplication } from '@helpers/generate_component.js';
import { generateAxiosInstance } from '@helpers/axios_provider.js';

const axios = generateAxiosInstance();

import VueSweetalert2 from 'vue-sweetalert2';
import 'sweetalert2/dist/sweetalert2.min.css';

generateApplication(App, "#header-login", {
    injections: [{
        name: 'locale',
        module: locale
    }, {
        name: '$axios',
        module: axios
    }],
    packages: [VueSweetalert2]
})