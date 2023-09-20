<template>
  <div class="fixed-plugin">
    <div class="shadow-lg card blur">
      <div class="pt-3 pb-0 bg-transparent card-header">
        <div class="float-start">
          <h5 class="mt-3 mb-0">Configurador de interfaz</h5>
        </div>
        <div class="mt-4 float-end" @click="toggleConfigurator">
          <button class="p-0 btn btn-link text-dark fixed-plugin-close-button">
            <i class="fa fa-times"></i>
          </button>
        </div>
        <!-- End Toggle Button -->
      </div>
      <hr class="my-1 horizontal dark" />
      <div class="pt-0 card-body pt-sm-3">
        <!-- Sidebar Backgrounds -->
        <div>
          <h6 class="mb-0">Colores del  menu</h6>
        </div>
        <a href="#" class="switch-trigger background-color">
          <div
              class="my-2 badge-colors text-start"
          >
            <span
                class="badge filter bg-gradient-primary"
                :class="{'active': color.includes('primary')}"
                data-color="primary"
                @click="sidebarColor('primary')"
            ></span>
            <span
                class="badge filter bg-gradient-dark"
                :class="{'active': color.includes('dark')}"
                data-color="dark"
                @click="sidebarColor('dark')"
            ></span>
            <span
                class="badge filter bg-gradient-info"
                :class="{'active': color.includes('info')}"
                data-color="info"
                @click="sidebarColor('info')"
            ></span>
            <span
                class="badge filter bg-gradient-success"
                :class="{'active': color.includes('success')}"
                data-color="success"
                @click="sidebarColor('success')"
            ></span>
            <span
                class="badge filter bg-gradient-warning"
                :class="{'active': color.includes('warning')}"
                data-color="warning"
                @click="sidebarColor('warning')"
            ></span>
            <span
                class="badge filter bg-gradient-danger"
                :class="{'active': color.includes('danger')}"
                data-color="danger"
                @click="sidebarColor('danger')"
            ></span>
          </div>
        </a>

        <div class="mt-2">
          <h6 class="mb-0">Menu pequeño</h6>
        </div>
        <div class="form-check form-switch ps-0">
          <input
              id="navbarMinimize"
              class="mt-1 form-check-input ms-auto"
              type="checkbox"
              :checked="!isPinned"
              @click="navbarMinimize"
          />
        </div>
      </div>

      <button class="btn btn-dark d-flex justify-content-center" @click="saveConfig" :disabled="loading">
        <div v-if="loading" class="text-center">
          <div class="spinner-border spinner-border-sm" role="status"></div>
        </div>

        Guardar configuración
      </button>
    </div>
  </div>
</template>

<script>
import { mapMutations, mapActions, mapState } from "vuex";
export default {
  name: "Configurator",
  inject: ['$axios'],
  data: () => ({
    loading: false,
    previousWidth: null
  }),
  computed: {
    ...mapState([
      "isPinned",
      "color",
    ]),
  },
  watch: {
    color: {
      handler: function (newValue) {
        document.querySelector("#sidenav-main").setAttribute("data-color", newValue);
      },
      inmediate: true
    }
  },
  methods: {
    ...mapMutations(["navbarMinimize", "toggleConfigurator"]),
    ...mapActions(["setCardBackground"]),

    sidebarColor(color = "success") {
      this.setCardBackground(color);
    },

    saveConfig() {
      if (this.loading) return;

      this.loading = true

      this.$axios.put('/profile', {
        data: {
          sidebar_colors: this.color,
          sidenav_mini: !this.isPinned
        }
      }).then(() => {
        this.$swal('','Se ha guardado la configuración de la interfaz.','success');
        this.toggleConfigurator();
      }).catch(() => {
        this.$swal('Oops..','Error en el servidor.','error');
      }).finally(() => {
        this.loading = false
      })
    },

    sidenavTypeOnResize() {
      if (window.screen.width < 768 && this.isPinned) {
        this.navbarMinimize()
      } else if (window.screen.width > 768 && !this.isPinned) {
        this.navbarMinimize()
      }
    }
  },

  beforeMount() {
    window.addEventListener("resize", this.sidenavTypeOnResize);
    window.addEventListener("load", this.sidenavTypeOnResize);
  },
};
</script>
