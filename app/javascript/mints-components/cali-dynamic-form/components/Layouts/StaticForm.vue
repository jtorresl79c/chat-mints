<template>
  <div class="d-flex flex-column" v-auto-animate>

    <div class="row">
      <div v-for="field in fields" :key="field.slug" class="my-1" :class="field?.extra_parameters?.styles" v-auto-animate>
        <Field :field="field" :hasError="errors[field.slug]?.$errors.length > 0"/>
      </div>
    </div>

  </div>
</template>
<script>
import { dynamicFormStore } from "../../stores/store";
import { mapStores, mapState } from 'pinia'

import Field from './Field.vue';
import ApiMethods from '../../mixins/api_methods.js'
import LayoutMethods from "../../mixins/layout_methods.js";

export default {
  inject: ['errors', '$axios'],
  mixins: [ApiMethods, LayoutMethods],
  computed: {
    ...mapStores(dynamicFormStore),
    ...mapState(dynamicFormStore, ['fields'])
  },
  mounted() {
    this.initializeContact();
  },
  provide: {
    include_error_message: true,
  },
  components: { Field },
  methods: {
    submit() {
      this.callApi();
    }
  }
}
</script>

<style lang="scss" scoped>
.error {
  color: red;
}
</style>