<template>
  <div v-auto-animate>
    <Header />

    <component ref="formLayout" :is="component" @resetVErrors="resetVErrors"/>

    <Footer @submit="submit"/>
  </div>
</template>
<script>
// Components
import Header from './components/Header&Footer/Header.vue';
import Footer from './components/Header&Footer/Footer.vue';
import Loading from './components/Layouts/Loading.vue';

// Packages
import { defineAsyncComponent } from "vue";
import { computed } from 'vue'
import Validations from './mixins/validations.js'
import useVuelidate from "@vuelidate/core";

// Store
import { dynamicFormStore } from "./stores/store";
import { mapStores, mapState, mapActions } from 'pinia'
export default {
  name: 'DynamicForm',
  inject: ['$axios'],
  mixins: [Validations],
  setup() {
    return { v$: useVuelidate() };
  },
  provide() {
    // use function syntax so that we can access `this`
    return {
      errors: computed(() => this.v$?.answers),
      submit: computed(() => this.submit),
      onFinished: computed(() => this.onFinished),
    }
  },
  props:{
    data: Object
  },
  components: {
    Header, Footer
  },
  beforeMount() {
    this.setFormData(this.data)
  },
  computed: {
    ...mapStores(dynamicFormStore),
    ...mapState(dynamicFormStore, ['answers', 'status', 'formType']),
    component() {
      return defineAsyncComponent({
        loader: () =>
            import (`./components/Layouts/${this.formType + 'Form'}.vue`),
        loadingComponent: Loading /* shows while loading */ ,
        delay: 0 /* delay in ms before showing loading component */ ,
        timeout: 3000 /* timeout after this many ms */ ,
      });
    },
  },
  methods: {
    ...mapActions(dynamicFormStore, ['setFormData']),
    submit() {
      if (this.status.submit) return;

      this.v$.$validate().then(value => {
        if (value) {
          this.$refs.formLayout.submit()
        }
      })
    },
    resetVErrors() {
      this.v$.$reset();
    },
    onFinished(data) {
      this.$emit('onFinished', data)
    }
  }
}
</script>