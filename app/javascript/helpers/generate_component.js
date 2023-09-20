import * as Vue from 'vue/dist/vue.esm-bundler';

export const generateApplication = (component, identifier, options ={
    injections: [],
    props: {},
    packages: [],
    components: [],
    globalEventsProvider: null
}) => {
    const element = document.querySelector(identifier)
    if (Boolean(element)) {
        const app = Vue.createApp(component, {...(options?.props || {}), ...element.dataset })
        app.config.unwrapInjectedRef = true
        
        if (Array.isArray(options?.injections)) {
            options.injections.forEach(({ name, module }) => { app.provide(name, module); });
        }
        
        if (Array.isArray(options?.packages)) {
            options.packages.forEach(module => { app.use(module); });
        }
        
        if (Array.isArray(options?.components)) {
            options.components.forEach(({ name, module }) => { app.component(name, module); });
        }
        
        if (options?.globalEventsProvider) {
            app.config.globalProperties.emitter = options.globalEventsProvider;
        }
        
        app.mount(identifier)
    }
};