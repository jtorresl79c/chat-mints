<template>
  <nav
      id="navbarBlur"
      class="shadow-none navbar navbar-main navbar-expand-lg"
      data-scroll="true"
  >
    <div class="px-3 py-1 container-fluid">
      <div class="navbar-nav align-items-center">
        <router-link class="m-0 navbar-brand" to="/app/dashboard">
          <div class="navbar-brand-img h-100"></div>
        </router-link>
      </div>

      <div
          id="navbar"
          class="mt-2 collapse navbar-collapse mt-sm-0 me-md-0 me-sm-4 d-none"
      >
        <div  class="pe-md-3 d-flex align-items-center ms-md-auto"></div>
        <ul class="navbar-nav justify-content-end">

          <div class="input-group">
            <input
                type="text"
                class="form-control navbar__search"
                placeholder="Buscar..."
                v-model="search"
                :disabled="status.search"
                v-on:keyup.enter="getSearchStatus"
                @focus="searchFocus"
                :id="inputUniqueId"
            />

            <span class="input-group-text text-body" @click.prevent="getSearchStatus">
              <div v-if="status.search" class="spinner-border-sm spinner-border"></div>

              <i class="fas fa-search" aria-hidden="true" v-else></i>
            </span>

            <div class="choices__list choices__list--dropdown is-active" aria-expanded="true" :id="uniqueId" v-show="showResults">
              <div class="choices__list" role="listbox">
                <router-link :to="option.url" v-for="(option, index) in results" :key="index">
                  <div id="choices--cali-searchable-list-item-choice-1"
                       class="choices__item choices__item--choice is-selected choices__item--selectable is-highlighted my-2"
                       role="option"
                       data-choice=""
                       data-id="1"
                       data-value="1"
                       data-select-text="Ir a la página"
                       data-choice-selectable=""
                       aria-selected="true">

                      {{ option.label }} / {{ getType(option.type) }}
                  </div>
                </router-link>

                <div v-if="results?.length === 0">
                  No se han encontrado resultados para esta búsqueda.
                </div>
              </div>
            </div>

          </div>

          <li class="px-3 nav-item d-flex align-items-center">
            <a
                class="p-0 nav-link text-body"
            >
              <i class="cursor-pointer fa fa-bell fixed-plugin-button-nav"></i>
            </a>
          </li>

          <li class="px-3 nav-item d-flex align-items-center">
            <a
                class="p-0 nav-link text-body"
                @click="toggleConfigurator"
            >
              <i class="cursor-pointer fa fa-cog fixed-plugin-button-nav"></i>
            </a>
          </li>

          <li class="px-3 nav-item d-flex align-items-center">
            <a
                class="p-0 nav-link text-body"
            >

              <div v-if="logout" class="spinner-border spinner-border-sm"></div>
              <i v-else class="cursor-pointer fas fa-user-circle"></i>
            </a>
          </li>

        </ul>
      </div>
    </div>
  </nav>
</template>
<script>
import {mapMutations, mapState, mapGetters} from "vuex";
import debounce from 'lodash/debounce';

export default {
  inject: ['$axios'],
  name: "Navbar",

  data: () => ({ logout: false, search: null, status: { search: null }, results: [], showResults: false }),

  computed: {

    uniqueId() {
      return 'search__' + this?.$?.type?.__scopeId + '__' + this?.$?.uid
    },

    inputUniqueId() {
      return 'search__input__' + this?.$?.type?.__scopeId + '__' + this?.$?.uid
    }
  },

  methods: {
    ...mapMutations(["toggleConfigurator", "setWhatever"]),
    async getSearchStatus() {
      if (!Boolean(this.search?.replaceAll(' ', '')?.length)) {
        this.results = null;
        this.showResults = false;
        return;
      }

      if (this.status.search) return

      this.status.search = true;

      this.$axios.get('/search?search=' + this.search).then(r => {
        this.results = r.data;
        this.showResults = true;
      }).finally(() => {
        this.status.search = false;
      })
    },

    getType(type) {
      if (type === 'contact') return 'Contactos';

      return 'Página'
    },

    manageClick(e) {
      if (!document.getElementById(this.uniqueId).contains(e.target) && !document.getElementById(this.inputUniqueId).contains(e.target)){
        this.showResults = false
      }
    },

    searchFocus() {
      if (this.results?.length > 0) this.showResults = true;
    }
  },

  created() {
    setTimeout(() => {
      window.addEventListener('click', this.manageClick, true);
    }, 250)
  },

  beforeUnmount() {
    window.removeEventListener('click', this.manageClick, true);
  }
};
</script>

<style lang="scss" scoped>
.navbar-brand {
  min-width: 14rem;
  margin-right: 1rem !important;
}

.navbar-brand-img {
  min-height: 60px;
  background-color: #939BAA;
}

.navbar__search {
  width: 30rem;
}

@media (max-width: 1200px) {
  .navbar__search {
    width: 15rem;
  }
}

@media (max-width: 1200px) {
  .navbar__search {
    width: 13rem;
  }
}
</style>

<style lang="scss">
@import "@mints-components/cali-searchable-list/styles.css";
</style>