// Store
import { dynamicFormStore } from "../stores/store";
import { mapStores, mapState, mapActions } from 'pinia'

export default {
 inject: ['onFinished'],
 computed: {
  ...mapStores(dynamicFormStore),
  ...mapState(dynamicFormStore, ['answers', 'buttonField', 'defaultApi']),
 },
 methods: {
  ...mapActions(dynamicFormStore, ['resetStep', 'changeStatus', 'resetAnswers']),
  callApi() {
    this.changeStatus({ key: 'submit', value: true });
   
    const url = this.buttonField?.extra_parameters?.api || this.defaultApi

    this.$axios.post(url, { data: this.answers }).then(() => {
      const successConfig = this.buttonField?.extra_parameters?.success_message;
      
      if (successConfig) {
       this.callSweetAlert(successConfig.title, successConfig.text, successConfig.icon)
      }
      
      this.resetStep();
      this.resetAnswers();
      this.onFinished(this.answers);
      
      setTimeout(async () => {
        if (typeof this.updateStepByAutofill === 'function') {
         await this.initializeContact();
         await this.updateStepByAutofill();
         this.$emit('resetVErrors');
        }
      })
    }).catch(e => {
      const errorConfig = this.buttonField?.extra_parameters?.error_message;
   
      if (errorConfig) {
       this.callSweetAlert(errorConfig.title, errorConfig.text, errorConfig.icon)
      }
    }).finally(() => {
      this.changeStatus({ key: 'submit', value: false });
    })
  },
  callSweetAlert(title, text, icon) {
   this.$swal.fire({ title, text, icon })
  }
 }
}