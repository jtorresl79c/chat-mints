<template>
  <!-- nav -->
  <navbar class="shadow-blur z-index-sticky"/>

  <main
      class="main-content position-relative border-radius-lg d-flex min-vh-85 my-3"
      v-auto-animate
  >
    <sidenav :custom-class="color" />

    <div class="router__view">
      <h5 v-if="!excludedPromos.includes(viewName)"> {{ viewName }} </h5>

      <div class="me-4" :class="{'mt-3': !excludedPromos.includes(viewName) }">
        <router-view ref="view"/>
      </div>
    </div>
  </main>

  <configurator
      :class="[showConfig ? 'show' : '']"
  />
</template>
<script>
import Sidenav from "./sidenav/Index.vue";
import Navbar from "./navbar/Index.vue";
import { mapMutations, mapState } from "vuex";
import Configurator from './configurator/Index.vue'
import debounce from "lodash/debounce";

export default {
  name: "App",
  inject: ['$axios'],
  components: {
    Sidenav,
    Navbar,
    Configurator
  },
  props: {
    me: Object
  },
  data: () => ({
    config: null,
    excludedPromos: ['Participante']
  }),
  computed: {
    ...mapState([ "color", "showConfig"]),
    currentPath() {
      return this.$route?.path
    },
    viewName() {
      return this.$route?.name
    }
  },
  mounted() {
    this.setMyInformation(this.me);

    if (window.innerWidth < 768) {
      this.navbarMinimize()
    }
  },
  watch: {
    currentPath() {
      this.resetObjects();
    }
  },
  methods: {
    ...mapMutations(["setMyInformation", "resetObjects", "navbarMinimize"]),
  }
};
</script>
