<template>
  <div class="d-flex flex-column" v-auto-animate>
    <div class="d-flex justify-content-left contact-step-form__label  text-left mb-2">
      <span class="contact-step-form__span mx-1 text-nowrap" v-if="step !== maxStep && !$contact"> {{ step }} / {{ maxStep }} </span>

      <template v-for="label in currentLabels">
        <LabelField :field="label"/>
      </template>

    </div>

    <div v-for="field in currentInputs" :key="field.slug" class="my-1" v-auto-animate>
      <div class="blue-bg">
        <Field :field="field" :hasError="errors[field.slug]?.$errors.length > 0"/>
      </div>
    </div>

  </div>
</template>
<script>
// Store
import { dynamicFormStore } from "../../stores/store";
import { mapStores, mapState, mapActions } from 'pinia'

import Field from './Field.vue';
import ApiMethods from '../../mixins/api_methods.js'
import LayoutMethods from "../../mixins/layout_methods.js";
import LabelField from "../Fields/LabelField.vue";

export default {
  inject: ['errors', '$axios'],
  mixins: [ApiMethods, LayoutMethods],
  provide: {
    include_error_message: false,
  },
  computed: {
    ...mapStores(dynamicFormStore),
    ...mapState(dynamicFormStore, ['step', 'maxStep', 'currentInputs', 'currentLabels']),
  },
  components: {LabelField, Field },
  async created() {
    await this.initializeContact();
    await this.updateStepByAutofill();
  },
  methods: {
    ...mapActions(dynamicFormStore, ['verifyIfKeysHasValue', 'nextStep']),

    submit() {
      if (this.step < this.maxStep) {
        this.nextStep()
      } else {
        this.callApi();
      }
    },

    async updateStepByAutofill() {
      const value = await this.verifyIfKeysHasValue();

      if (value && this.step < this.maxStep) {
        this.nextStep();
        await this.updateStepByAutofill();
      }
    }
  }
}
</script>

<style lang="scss" scoped>
 .error {
   color: red;
 }
 
.m-input-wrapper-input{
  border-radius: 0px 4px 4px 0px !important;
}
.vs__dropdown-toggle{
  color: white !important;
  padding: 0 !important;
  border: 0 !important;
  height: 41px;
}
.vs__search{
  color: white !important;
}
.vs--single .vs__selected{
  color: white;
}
.vs__selected-options, .vs__actions{
  background-color: rgba(255,255,255,.3);
  border: 1px solid white;
  flex-wrap: nowrap !important;
  height: 41px;
}
.vs__selected-options{
  border-radius: 4px 0 0 4px !important;
  border-right: 0;
}
.vs__actions{
  border-radius: 0px 4px 4px 0px !important;
  border-right: 0;
}
.vs__open-indicator{
  fill: white !important;
  width: 14px;
}
.vs--disabled .vs__dropdown-toggle, .vs--disabled .vs__clear, .vs--disabled .vs__search, .vs--disabled .vs__selected, .vs--disabled .vs__open-indicator{
  background-color: rgba(255,255,255,.3) !important;
}
</style>