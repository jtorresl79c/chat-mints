import App from '@views/settings/login/App.vue'
import { generateApplication } from '@helpers/generate_component.js';

import { autoAnimatePlugin } from "@formkit/auto-animate/vue"
import VueSweetalert2 from 'vue-sweetalert2';
import 'sweetalert2/dist/sweetalert2.min.css';

generateApplication(App, "#app", { packages: [VueSweetalert2, autoAnimatePlugin]})