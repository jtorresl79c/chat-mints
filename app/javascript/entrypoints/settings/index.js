import App from '@views/settings/index/layout/Index.vue'
import { generateApplication } from '@helpers/generate_component.js';
import { generateRouter } from "@routers/settings.js";
import store from '@stores/settings.js';
import { generateAxiosInstance } from '@helpers/axios_provider.js'

import { autoAnimatePlugin } from "@formkit/auto-animate/vue"
import VueSweetalert2 from 'vue-sweetalert2';
import 'sweetalert2/dist/sweetalert2.min.css';

const router = generateRouter(['all'])

generateApplication(
  App,
  "#app",
  {
    injections: [{ name: 'user', module: user }, { name: '$axios', module: generateAxiosInstance('/api/v1/settings/') }],
    packages: [VueSweetalert2, autoAnimatePlugin, router, store]
  }
)