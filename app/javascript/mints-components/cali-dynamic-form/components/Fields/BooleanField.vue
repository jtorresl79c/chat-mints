<template>
  <div class="d-flex">
    <input v-model="localValue"
       type="checkbox"
       :checked="localValue"
       :id="`enum_${field.slug}`"
       :name="field.slug"
       :placeholder="field.placeholder"
       :readonly="readonly"
       @keyup.enter="submit"/>

    <label v-if="field.help" class="mx-2" :for="`enum_${field.slug}`"> {{ field.help }} </label>
  </div>


  <label class="general-register__paragraph error_message text-start" v-if="include_error_message && hasError"> {{field.validation_text}} </label>
</template>
<script>
export default {
  inject: ['submit', 'include_error_message'],
  props:{
    field: {
      type: Object
    },
    modelValue: {
      required: true
    },
    hasError: Boolean
  },
  computed: {
    localValue: {
      get() {
        return this.modelValue;
      },
      set(newValue) {
        return this.$emit('update:modelValue', newValue);
      }
    },
    styles() {
      return this.field?.extra_parameters?.styles
    },
    readonly() {
      return this.field?.extra_parameters?.readonly
    }
  }
}
</script>
<style scoped>
  @import '../../styles/errors.scss';
</style>