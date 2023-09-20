// import App from '@components/header-login/App.vue';
// import { generateApplication } from '@helpers/generate_component.js';
// import { generateAxiosInstance } from '@helpers/axios_provider.js';

// const axios = generateAxiosInstance();

// import VueSweetalert2 from 'vue-sweetalert2';
// import 'sweetalert2/dist/sweetalert2.min.css';

// generateApplication(App, "#header-login", {
//     injections: [{
//         name: 'locale',
//         module: locale
//     }, {
//         name: '$axios',
//         module: axios
//     }],
//     packages: [VueSweetalert2]
// })

// import App from '@components/header-login/App.vue';
import { generateApplication } from '@helpers/generate_component.js';
import { generateAxiosInstance } from '@helpers/axios_provider.js';

import App from '@components/App.vue';

const axios = generateAxiosInstance("");

// import VueSweetalert2 from 'vue-sweetalert2';
// import 'sweetalert2/dist/sweetalert2.min.css';

import router from '@routers/router'
import store from '@stores/index'


router.beforeEach((to, from, next) => {
    if (to.matched.some(record => record.meta.requiresAuth)) {
        if (!localStorage.getItem('sessionToken')) {
            console.log('ksksks')
            next({
                name: 'login',
            })
        } else {
            next()
        }
    }
    
    else if(to.matched.some(record => record.meta.requiresVisitor)){
        if (localStorage.getItem('sessionToken')) {
            next({
                name: 'principal',
            })
        } else {
            next()
        }
    }
    
    else{
        next()
    }

})



generateApplication(App, "#app", {
    injections: [
    {
        name: '$axios',
        module: axios
    }
    ],
    packages: [router, store]
})