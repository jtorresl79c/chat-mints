import App from '@mints-components/cali-dynamic-form/App.vue';
import { generateApplication } from '@helpers/generate_component.js';
import { generateAxiosInstance } from '@helpers/axios_provider.js';

// Packages
import { autoAnimatePlugin } from "@formkit/auto-animate/vue"
import VueSweetalert2 from 'vue-sweetalert2';
import 'sweetalert2/dist/sweetalert2.min.css';
import { createPinia } from 'pinia'

const injections = [{
  name: '$axios',
  module: generateAxiosInstance()
}, {
  name: '$contact',
  module: typeof contact !== 'undefined' ? contact : null
}]
let formContainers = document.querySelectorAll(`div[id^="dynamic-form-"]`);

formContainers.forEach(element => {
  let index = element.dataset.formId;
  const props = { data: typeof forms !== 'undefined' ? forms[index] : null }
  generateApplication(App, `#dynamic-form-${index}`, { injections, props, packages: [VueSweetalert2, autoAnimatePlugin, createPinia()]})
})