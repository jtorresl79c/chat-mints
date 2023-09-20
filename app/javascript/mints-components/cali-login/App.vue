<template>
  <div class="cali__login-app">
    <div class="cali__login-row">
      <div class="cali__login-login_container">
        <div class="cali__login-card">
          <div class="cali__login-text-center cali__login-card-header">
            <h5>Bienvenido</h5>
            <span>
              {{ message }}
            </span>
          </div>

          <div class="cali__login-card_body">
            <AuthForm
                ref="authForm"
                :options="options"
                @onSubmit="onSubmit"
                @onError="onError"
                @changeMode="changeMode"/>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>

import { defineComponent } from "vue";
import AuthForm from "./AuthForm.vue";

export default defineComponent({
  props: {
    options: {
      type: Object,
      default: () => ({ magicLink: { enabled: true }, password: { enabled: true } })
    }
  },
  components: { AuthForm },
  data: () => ({ message: 'Ingresa tu correo y recibe el enlace de acceso' }),
  methods: {
    resetErrors() { this.$refs.authForm.resetErrors() },
    onSubmit(response) { this.$emit('onSubmit', response) },
    onError(error) { this.$emit('onError', error) },
    changeMode(mode) { this.message = mode ? 'Inicia sesión con tu correo y contraseña' : 'Ingresa tu correo y recibe el enlace de acceso' }
  }
})
</script>

<style >
@import "styles.css";
</style>