import { defineStore } from 'pinia'

export const dynamicFormStore = defineStore('dynamicForm', {
  state: () => ({
    form: {}, answers: {},
    step: 1, status: {}
  }),
  actions: {
    updateAnswer({ key, value }) {
      this.answers[key] = value
    },
    setFormData(payload) {
      this.form = payload
    },
    nextStep() {
      this.step ++;
    },
    resetStep() {
      this.step = 1
    },
    changeStatus({ key, value }) {
      this.status[key] = value
    },
    resetAnswers() {
      this.answers = {}
    },
    verifyIfKeysHasValue() {
      return this.currentInputs.every(field => Boolean(this.answers[field.slug]))
    }
  },
  getters: {
    // Global getters
    formType: (state) => state.form?.config_json?.is_progressive_form ? 'Progressive' : 'Static',
    isProgressive() { return this.formType === 'Progressive' },
    title: (state) => state.form?.config_json?.form_title,
    description: (state) => state.form?.description,
    fields: (state) => state.form?.config_json?.fields,
    inputFields() { return this.fields?.filter(f => f.data_type_enum !== 16) },
    labelFields() { return this.fields?.filter(f => f.data_type_enum === 16) || [] },
    buttonField() { return this.labelFields.find(f => f?.extra_parameters?.is_footer_button) },
    defaultApi: (state) => state.form?.slug ? '/api/v1/forms/' + state.form.slug : '',
    submitStatus: (state) => state.status?.submit,
    // Progressive form getters
    maxStep() {
      return this.inputFields?.reduce((carry, field) => {
        return field?.extra_parameters?.step > carry ? field.extra_parameters.step : carry
      }, 1)
    },
    currentInputs(state) { return this.inputFields.filter(field => field.extra_parameters?.step === state.step) },
    currentLabels(state) { return this.labelFields.filter(field => field.extra_parameters?.step === state.step) },
  }
});
