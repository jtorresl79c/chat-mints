<template>
  <form role="form" class="cali__login-text-start" v-auto-animate>
    <div class="cali__login-mb-3">
      <div class="cali__login-group">
        <label for="email"> Correo electrónico</label>

        <input id="email"
               type="email"
               class="cali__login-input"
               name="email"
               placeholder="Correo electrónico"
               :class="{'cali__login-error': v$?.credentials?.email?.$errors?.length > 0}"
               v-model="credentials.email">
      </div>
    </div>

    <div class="cali__login-mb-3" v-if="options?.password?.enabled && showPasswordField">
      <div class="cali__login-group">
        <label for="password"> Contraseña </label>

        <input id="password"
               type="password"
               class="cali__login-input"
               name="password"
               placeholder="Contraseña"
               :class="{'cali__login-error': v$?.credentials?.password?.$errors?.length > 0}"
               v-model="credentials.password">
      </div>
    </div>

    <div class="cali__login-text-center">
      <button class="cali__login-button"
              :disabled="loading"
              @click.prevent="validate">
        <div v-if="loading" class="cali__login-spinner"></div>
        {{ showPasswordField ? 'Iniciar sesión' : 'Enviar' }}

      </button>
    </div>

    <div class="cali__login-text-end"
         :class="{'cali__login-link-mt': !showPasswordField}"
         v-if="options?.password?.enabled && options?.magicLink?.enabled">
      Si prefieres, <a class="cali__login-link" @click.prevent="changeFields">
        {{ showPasswordField ? 'inicia sesión con un Magic Link' : 'inicia sesión con tu contraseña' }}
      </a>
    </div>
  </form>
</template>

<script>
import useVuelidate from "@vuelidate/core";
import { required, email } from '@vuelidate/validators'

export default {
  setup() {
    return { v$: useVuelidate() };
  },
  props: {
    options: {
      type: Object,
      required: true
    }
  },
  data: () => ({
    credentials: {},
    showPasswordField: false,
    loading: false
  }),
  computed: {
    credentialsRules() {
      let defaultRules = { credentials: { email: { required, email }}};

      if (this.showPasswordField) {
        defaultRules.credentials.password = { required }
      }

      return defaultRules
    },
    url() {
      return this.showPasswordField ? this.options?.password?.url : this.options?.magicLink?.url
    },
    headers() {
      return { Accept: "application/json", "Content-Type": "application/json", ...this.options?.headers }
    },
    type() {
      return this.showPasswordField ? 'password' : 'magic link'
    }
  },
  methods: {
    changeFields() {
      this.v$.$reset()
      this.showPasswordField = !this.showPasswordField;

      this.$emit('changeMode', this.showPasswordField)
    },
    resetErrors() {
      this.v$.$reset();
    },
    validate() {
      this.v$.$validate().then(value => {
        if (value) {
          this.submit();
        }
      });
    },
    async submit() {
      if (this.loading) return;
      this.loading = true;

      const options = {
        method: "POST",
        headers: this.headers,
        body: JSON.stringify({ data: { ...this.credentials, type: this.type} }),
      };

      if (this.url) {
        try {
          let response = await fetch(this.url, options)

          if (response.status >= 200 && response.status < 300) {
            this.$emit('onSubmit', { ...response, type: this.type })
            this.credentials = {};
            this.resetErrors();
          } else {
            this.$emit('onError', response)
          }
        } catch (e) {
          this.$emit('onError', e)
        }
      } else {
        console.error('No api configured for ' + this.type + ' request, options prop example: ', {
          magicLink: { enabled: true, url: 'api_url'},
          password: { enabled: true, url: 'api_url' },
          headers: '...your headers here'
        })
      }

      this.loading = false;
    }
  },
  validations() {
    return this.credentialsRules;
  }
}
</script>