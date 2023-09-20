// Store
import { dynamicFormStore } from "../stores/store";
import { mapStores, mapState } from 'pinia'
import { attachValidations } from '@helpers/validator_provider.js';

export default {
  computed: {
    ...mapStores(dynamicFormStore),
    ...mapState(dynamicFormStore, ['isProgressive', 'currentInputs', 'inputFields']),
    validatableFields() {
      return this.isProgressive ? this.currentInputs : this.inputFields
    },
    customValidations() {
      if (!this.validatableFields) return {};
      
      let validations = {}
      let formState = {}
      
      
      this.validatableFields.forEach(field => {
        validations[field.slug] = attachValidations(field)
        formState[field.slug] = null
      });
  
      return { answers: validations }
    }
  },
  validations() {
    return this.customValidations
  }
}