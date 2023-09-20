<template>
    <Modal v-if="showModal" modalSize="sm" @close="hide()">
        <template v-slot:header>
            <h5 class="modal-title pl-3"></h5>
        </template>

        <template v-slot:body>
            <div class="pl-3 pr-3">
                <h5>Inicia sesión</h5>
                <p class="description mb-4"> {{ titleText }} </p>

                <div class="form-group" :class="{ error: v$.user.email.$errors.length }">
                    <label for="">Email</label>
                    <input class="form-control" placeholder="Enter your email" type="email" v-model="user.email">
                    <div class="pre-icon os-icon os-icon-user-male-circle"></div>
                        <!-- error message -->
                    <div class="input-errors" v-for="(error, index) of v$.user.email.$errors" :key="index">
                        <div class="error-msg">{{ error.$message }}</div>
                    </div>
                </div>

            </div>
        </template>

        <template v-slot:footer>
            <div>
                <button v-if="buttonText" 
                    class="btn px-4 btn-secondary d-flex justify-content-center"
                    @click.prevent="submit"
                    :disabled="isBusy">
                    
                    <div class="pe-3"> {{ buttonText }} </div>
                    <div v-if="isBusy" class="text-center">
                        <div class="spinner-border spinner-border-sm" role="status"></div>
                    </div>
                </button>
            </div>
        </template>
    </Modal>
</template>

<script nonce>
import Modal from '@mints-components/cali-modal/App.vue';
import useVuelidate from "@vuelidate/core";
import { required, email } from '@vuelidate/validators'

export default {
    inject: ['locale', '$axios'],
    components:{ Modal },

    setup() {
      return { v$: useVuelidate() };
    },

    data: () => ({
      user: {},
      isBusy: false,
      showModal: false
    }),

    computed: {
      buttonText() {
        return this.locale === 'es' ? 'Enviar' : 'Submit';
      },
      titleText() {
        return this.locale === 'es' ? 'Escribe tu correo electrónico y te enviaremos un Magic Link a tu correo electrónico para tu inicio de sesión' : 'Write your email and we will send you a Magic Link to your email for your login'
      },
      modalSuccessText() {
        return this.locale === 'es' ? 'Se envió el magic link' : 'Magic link sent'
      },
      modalErrorText() {
        return this.locale === 'es' ? 'Han ocurrido problemas en el servidor, intenta más tarde' : 'There have been problems on the server, please try again later'
      },
      computedValidations() {
        return { user: { email: { required, email }}}
      }
    },

    methods: {
      show() { this.showModal = true },

      submit(){
        this.v$.$validate().then(value => {
          if (value) this.verifyEmail();
        });
      },

      verifyEmail() {
        this.isBusy = true;

        this.$axios.post('/api/v1/login/check-email', {
          data: this.user
        }).then((r) => {
          if (r.data.data === 'email_exists') {
            this.sendMagicLink();
          } else {
            this.isBusy = false;
          }
        }).catch(e => {
          this.displayErrorMessage();
        }).finally(() => {
          this.isBusy = false;
        });
      },

      sendMagicLink(){
        this.$axios.post(`/api/v1/login/send-magic-link`, {
          data: this.user
        }).then((r)=>{
          this.$swal.fire({
            icon: 'success',
            title: this.modalSuccessText,
            showConfirmButton: true
          });
        }).catch(e => {
          this.displayErrorMessage();
        }).finally(() => {
            this.isBusy = false;
        });
      },

      displayErrorMessage() {
        this.$swal.fire({
          icon: 'error',
          title: this.modalErrorText,
          showConfirmButton: true
        });
      },

      hide(){
        this.showModal = false;
        this.user = { given_name: null, last_name: null, email: null }
        this.v$.$reset()
      }
    },
    validations() {
        return this.computedValidations;
    }
}
</script>