<template>
  <main class="mt-0 main-content">
    <main class="mt-0 main-content main-content-bg">
      <section>
        <div class="page-header min-vh-100">
          <div class="container-fluid">
            <div class="d-flex flex-wrap justify-content-center">
              <div
                  class="mx-xl-8 col-xl-4 col-lg-7 col-md-8 col-12 d-flex flex-column"
              >

                <CaliLogin :options="{
                    magicLink: { enabled: true, url: '/api/v1/settings/magic-link-login'},
                    password: { enabled: true, url: '/api/v1/settings/login-password' },
                    headers: {
                      'x-api-key': '9c6334a7-8215-46ff-8ec9-f442cdc43cac'
                    }
                  }"
                   @onSubmit="onSubmit"
                   @onError="onError"/>

              </div>
              <div class="col-md-6 d-md-block d-none">
                <div
                    class="top-0 oblique position-absolute h-100 me-n8"
                >
                  <div
                      class="bg-cover oblique-image position-absolute fixed-top ms-auto h-100 z-index-0 ms-n6"
                      :style="{
                      backgroundImage: 'url(https://comeximplprod-16905.kxcdn.com/public-assets/login-background)'
                    }"
                  ></div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>
    </main>
  </main>
</template>

<script>
import CaliLogin from '@mints-components/cali-login/App.vue';

export default {
  components: { CaliLogin },
  methods: {
    onSubmit(response) {
      let title = 'Magic link enviado'
      let text = 'Se ha enviado el magic link...'

      if (response.type === 'password') {
        title = 'Autenticación correcta'
        text = 'Iniciando sesión...'
      }

      this.$swal.fire({
        icon: 'success',
        title: title,
        text: text
      })

      if (response.type === 'password') {
        setTimeout(() => {
          window.location.href = '/settings'
        }, 1250)
      }
    },
    onError(e) {
      this.$swal.fire({
        icon: 'error',
        title: 'Oops...',
        text: 'Credenciales inválidas.'
      })
    }
  }
};
</script>
