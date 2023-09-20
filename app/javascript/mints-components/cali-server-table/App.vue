<template>
  <div class="cali__server-table me-4">
    <div class="cali__server-table__col12">
      <div class="cali__server-table__card">

        <div class="cali__server-table__filters">

          <slot name="custom_filters" :filters="filters">
            <div></div>
          </slot>

          <input v-if="options?.search"
              v-model="search"
              class="cali__server-table__input"
              :placeholder="options?.searchPlaceholder || 'Buscar...'"/>

        </div>

        <!-- Card header -->
        <template v-if="options?.download?.onClick || options?.create?.onClick">
          <div class="cali__server-table__row cali__server-table__group">
            <a class="text-end col-12 col-md-8 col-lg-9 btn bg-gradient-info"
               style="cursor:pointer;width: fit-content;"
               v-if="options?.download?.onClick"
               @click.prevent="options.download.onClick">

              <div v-if="options?.download?.loading" class="spinner-border spinner-border-sm" role="status"></div>

              <i class="fa fa-cloud-download-alt" v-else></i>
              {{ options?.download?.text || 'Descargar' }}
            </a>

            <button class="btn btn-info col-12 col-md-4 col-lg-3 ms-2" @click="options.create.onClick" v-if="options?.create?.onClick">
              <i class="fa fa-plus"></i>
              {{options?.create?.text || 'Crear'}}
            </button>
          </div>
        </template>

        <div class="table-responsive">
          <table class="table table-flush">
            <Headers :headers="options?.headers || []" />

            <tbody>

              <Loaders v-if="status.get.isBusy"
                     :size="filters.pageSize"
                     :keys="options?.headers"/>

              <template v-else-if="objects[id]?.length > 0">
                <tr v-for="(object, index) in objects[id]" :key="'object_' + index">
                  <slot name="row" :row="object">
                    <td class="data-column text-sm font-weight-normal" v-for="key in Object.keys(object)">
                      {{object[key]}}
                    </td>
                  </slot>
                </tr>
              </template>

              <EmptyState v-else />
            </tbody>
          </table>
        </div>

        <Pagination :id="id" v-model="filters" :pages="pages" :objectType="options?.objectType"/>

      </div>
    </div>
  </div>
</template>

<script>
import { mapMutations, mapState } from 'vuex'
import debounce from 'lodash/debounce';
import Headers from "./components/Headers.vue";
import Loaders from "./components/Loaders.vue";
import EmptyState from "./components/EmptyState.vue";
import Pagination from "./components/Pagination.vue";

export default {
  name: "CaliServerTable",
  components: { Pagination, EmptyState, Loaders, Headers },
  inject: ['$axios'],
  props: {
    id: {
      type: Number,
      default: 1
    },
    options: {
      type: Object,
      default: () => ({}),
      api: String,
      objectType: String,
      searchPlaceholder: String,
      search: { type: Boolean, default: true },
      download: {
        type: Object,
        default: () => ({}),
        text: String,
        onClick: Function,
        loading: Boolean
      },
      create: {
        type: Object,
        default: () => ({}),
        text: String,
        onClick: Function
      },
      headers: Array,
      stopMountCall: Boolean
    },
  },
  data: () => ({
    dataTable: null,
    search: null,
    filters: {
      page: 1,
      pageSize: 10,
      search:  null,
      sort: null
    },
    pageChanged: false
  }),
  computed: {
    ...mapState(['objects', 'status', 'meta']),
    pages() {
      return this.meta[this.id]?.total ? Math.ceil(this.meta[this.id].total / this.filters.pageSize) : 0
    }
  },
  watch: {
    'search': {
      handler: debounce(function (newValue) {
        this.filters.search = newValue
        this.filters.page = 1;
      }, 500),
      immediate: false
    },
    'filters': {
      handler: debounce(function () {
        this.getObjects();
      }, 250),
      immediate: false,
      deep: true
    }
  },
  methods: {
    ...mapMutations(['updateStatus', 'setObjects', 'setMeta']),
    getObjects() {
      if (this.options?.api) {

        this.updateStatus({key: 'get', value: true})
        this.setObjects({key: this.id, value: []});

        const urlParams = new URLSearchParams(this.removeEmpty(this.filters)).toString();
        const url = this.options.api.includes('?') ? this.options.api + urlParams : this.options.api + '?' + urlParams

        this.$axios.get(url).then(response => {
          this.setObjects({key: this.id, value: response.data.data});
          this.setMeta({key: this.id, value: response.data.meta});
        }).finally(() => {

          setTimeout(() => {
            this.updateStatus({key: 'get', value: false})
          }, 375)
        })
      } else {
        console.warn("No api configured: options/api")
      }
    },

    removeEmpty(obj) {
      let helper = JSON.parse(JSON.stringify(obj));
      Object.keys(helper).forEach(key => {
        if(helper[key] === null || helper[key] === '') delete helper[key]
      })
      return helper;
    },

    removeObject(id) {
      let found = this.objects[this.id].findIndex(x => x.id === id)

      if (found !== -1) {
        this.objects[this.id].splice(found, 1)
      }
      this.meta[this.id].total -= 1
      this.meta[this.id].filtered -= 1
    },

    updateObject(payload, key, method = null) {
      let found = this.objects[this.id].findIndex(x => x.id === payload.id)

      if (found !== -1) {
        if (method) {
          this.objects[this.id][found] = method(this.objects[this.id][found])
        } else {
          this.objects[this.id][found][key] = payload[key]
        }
      }
    },

    createObject(payload) {
      this.objects[this.id].unshift(payload)
      if (this.objects[this.id].length > this.filters.pageSize) this.objects[this.id].pop()
    },

    refresh() {
      this.getObjects();
    },

    updateMultiplesObjects(objectsIds, key, method) {
      const objects = this.objects[this.id].filter(o => objectsIds.includes(o.id))

      objects.forEach(o => {
        this.updateObject(o, key, method);
      })
    },

    removeObjectRelation(id, relationId, relation) {
      const objFound = this.objects[this.id].findIndex(o => o.id === id)

      if (objFound !== -1) {
        const rFound = this.objects[this.id][objFound]['relationships'][relation].findIndex(r => r.id === relationId);

        if (rFound !== -1) {
          this.objects[this.id][objFound]['relationships'][relation].splice(rFound, 1)
        }
      }
    }
  },

  mounted() {
    if (!this.options?.stopMountCall) {
      this.getObjects();
    }
  }
};
</script>
<style lang="scss">
@import "styles";
</style>