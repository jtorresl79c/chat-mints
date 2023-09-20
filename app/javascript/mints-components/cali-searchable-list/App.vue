<template>
  <div class="cali__searchable__list-container">
    <select
        id="cali-searchable-list"
        class="cali__searchable__list-select is-loading"
        name="cali-searchable-list"
        v-model="localValue"
        :multiple="config?.multiple"
    >
      <option v-for="(option, index) in options"
              :value="option?.value || option"
              :key="index"
              :disabled="option?.disabled">
        {{ option?.label || option }}
      </option>

    </select>
    <div class="cali__searchable__list-spinner" v-if="config?.loading"></div>
  </div>
</template>
<script>
import * as Choices from "choices.js";
import debounce from "lodash/debounce";

export default {
  props: {
    config: {
      type: Object,
      default: () => ({
        placeholder: null,
        options: [],
        multiple: false,
        removeItems: false,
        search: true,
        loadingText: 'Loading...',
        noResultsText: 'No results found',
        disabled: false,
        loading: false,
      })
    },
    modelValue: [Array, String],
  },
  data: () => ({
    loading: true,
    filters: {},
    choicesInstance: null,
    apiOptions: []
  }),
  computed: {
    localValue: {
      get() {
        return this.modelValue
      },
      set(newValue) {
        this.$emit('update:modelValue', newValue)
      }
    },
    options() {
      return (typeof this.config?.options === 'function' ? [] : this.config?.options) || []
    },
    params() {
      return typeof this.config?.options === 'function' ? new URLSearchParams(this.filters).toString() : null;
    }
  },
  watch: {
    'filters.search': {
      handler: debounce(async function () {
        if (typeof this.config?.options === 'function') {
          this.apiOptions = await this.config.options(this.params)
          await this.choicesInstance.setChoices(this.apiOptions);
        }
      }, 500),
      immediate: true,
      deep: true
    },
    'config.loading': {
      handler: function (newValue) {
        if (newValue) {
          this.choicesInstance?.disable();
        } else {
          this.choicesInstance?.enable();
        }
      },
      immediate: true
    },
  },
  mounted() {
    if (document.getElementById("cali-searchable-list")) {
      let element = document.getElementById("cali-searchable-list");
      this.choicesInstance = new Choices(element, {
        removeItems: this.config?.removeItems,
        removeItemButton: this.config?.removeItems,
        searchEnabled: this.config?.search,
        searchChoices: this.config?.search,
        placeholderValue: this.config?.placeholder,
        loadingText: this.config?.loadingText,
        noResultsText: this.config?.noResultsText,
        addItems: !this.config?.disabled,
        noChoicesText: this.config?.noChoicesText,
        classNames: {
          loadingState: 'is-loading'
        },
      });

      element.addEventListener(
          'search',
          (event) => {
            this.filters.search = event.detail.value
          },
          false,
      );
    }
  },
  methods: {

  }
}
</script>
<style>
@import "styles.css";
</style>