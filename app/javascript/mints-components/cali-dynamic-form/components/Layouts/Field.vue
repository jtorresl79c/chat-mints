<template>
  <component :is="componentField" v-model="localValue" :field="field" :hasError="hasError"/>
</template>
<script>
import { defineAsyncComponent } from 'vue'
import Loading from "./Loading.vue";

// Store
import { dynamicFormStore } from "../../stores/store";
import { mapStores, mapState, mapActions } from 'pinia'

export default {
  props: {
    field: {
      type: Object
    },
    hasError: {
      type: Boolean,
      default: false
    }
  },
  computed: {
    ...mapStores(dynamicFormStore),
    ...mapState(dynamicFormStore, ['answers']),
    componentName() {
      // Fields by data_type_enum
      if (this.field.data_type_enum >= 10 && this.field.data_type_enum < 15 && this.field.slug !== 'email') return 'TextField';
      if (this.field.data_type_enum === 15) return 'PhoneField';
      if (this.field.data_type_enum === 16 && [false, undefined].includes(this.field?.extra_parameters?.is_button || this.field?.extra_parameters?.is_footer_button)) return 'LabelField';
      if (this.field.data_type_enum === 21) return 'BooleanField';

      // Field by slug
      if (this.field.slug === 'email') return 'EmailField';

      return null
    },
    componentField() {
      return this.componentName ? defineAsyncComponent({
        loader: () =>
            import (`../Fields/${this.componentName}.vue`),
        loadingComponent: Loading /* shows while loading */ ,
        delay: 0 /* delay in ms before showing loading component */ ,
        timeout: 3000 /* timeout after this many ms */ ,
      }) : null;
    },
    localValue: {
      get() {
        return this.answers[this.field.slug]
      },
      set(newValue) {
        this.updateAnswer({ key: this.field.slug, value: newValue })
      }
    }
  },
  methods: {
    ...mapActions(dynamicFormStore, ['updateAnswer'])
  }
}
</script>

<style lang="scss">
.register-form {
  .vue-phone-number-input {
    border-color: rgb(216, 216, 216) !important;
    background-color: transparent !important;
    border: 1px solid;
    height: 26px !important;
  }

  .input-tel__input,
  .country-selector__input {
    height: 26px !important;
    max-height: 26px !important;
    min-height: 26px !important;
    border-radius: 0;
    border: 1px solid white !important;
  }

  .country-selector {
    .country-selector__country-flag {
      top: 14px !important;
      left: 40px !important;
    }

    .country-selector__label {
      font-size: 10px !important;
    }

    .country-selector__toggle {
      top: calc(40% - 11px) !important;
    }
  }

  .input-tel {
    left: 1px;

    .input-tel__label {
      font-size: 9px;
      top: 0px;
    }
  }
}
</style>