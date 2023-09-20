<template>
  <div class="dataTable-bottom text-center px-3" v-if="meta[id]">
    <div class="dataTable-info float-start">
      Mostrando {{objects[id].length === 0 && localValue.page === 1 ? 0 : (localValue.page - 1) * localValue.pageSize + 1}} ..
      {{status?.get?.isBusy ? '?' : (localValue.page - 1) * localValue.pageSize + meta[id].filtered}} de
      {{meta[id].total + ' ' + (objectType || 'objetos')}}

    </div>

    <template v-if="pages > 1">
      <label class="text-nowrap" style="display: inline-block;">Mostrar por página</label>
      <select class="section__form-input bg-white ms-3 input-type-1__border" style="display: inline-block;max-width: 75px;" v-model="localValue.pageSize">
        <option v-for="size in pageSizes" :value="size"> {{ size }} </option>
      </select>

      <nav class="dataTable-pagination">
        <ul class="dataTable-pagination-list">
          <a v-if="localValue.page > 1" href="#" class="page" @click.prevent="localValue.page -= 1;">‹</a>

          <li class="pager" v-for="i in pages">
            <a v-if="showPage(i)"
               href="#"
               class="page"
               :class="i === localValue.page ? 'active' : ''"
               @click.prevent="localValue.page = i;">
              {{ i }}
            </a>
          </li>

          <a v-if="localValue.page < pages" href="#" class="page" @click.prevent="localValue.page += 1;">›</a>
        </ul>
      </nav>
    </template>

    <div class="d-flex align-items-center" v-else>
      <label class="text-nowrap" style="display: inline-block;">Mostrar por página</label>
      <select class="section__form-input bg-white ms-3 input-type-1__border" style="display: inline-block;max-width: 75px;" v-model="localValue.pageSize">
        <option v-for="size in pageSizes" :value="size"> {{ size }} </option>
      </select>
    </div>
  </div>
</template>

<script>
import { mapState } from 'vuex'

export default {
  props: {
    id: {
      type: Number,
      default: 1
    },
    modelValue: {
      type: Object,
      required: true
    },
    pages: Number,
    objectType: String
  },
  data: () => ({ pageSizes: [10,25,50,75,100] }),
  computed: {
    ...mapState(['objects', 'status', 'meta']),
    localValue: {
      get() {
        return this.modelValue
      },
      set(newValue) {
        this.$emit('update:modelValue', newValue)
      }
    }
  },
  methods: {
    showPage(i) {
      return this.modelValue.page === i ||
          this.modelValue.page === (i - 1) ||
          this.modelValue.page === (i - 2) ||
          (this.modelValue.page < 2 && i === 3) ||
          (this.modelValue.page === (i + 1) && this.modelValue.page > (this.pages - 2))
    },
  }
}
</script>