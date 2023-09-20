<template>
  <label class="general-register__paragraph align-self-start " v-if="field.help"> {{field.help}}</label>

    <input v-model="localValue"
       v-if="field.data_type_enum === 10"
       type="text"
       class="form-control mt-3"
       :class="{'error': hasError}"
       :id="`enum_${field.data_type_enum}`"
       :name="field.slug"
       :placeholder="field.placeholder"
       :readonly="readonly"
       @keyup.enter="submit"/>

  <!-- text area -->
  <textarea v-model="localValue"
    v-else-if="field.data_type_enum === 11"
    type="text"
    class="form-control mt-3"
    :id="`enum_${field.data_type_enum}`"
    :class="{'error': hasError}"
    :name="field.slug"
    :placeholder="field.placeholder"
    rows="8"
    :readonly="readonly"
    @keyup.enter="submit"/>

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
    readonly() {
      return this.field?.extra_parameters?.readonly
    }
  }
}
</script>

<style lang="scss" scoped>
  @import '../../styles/errors';
  textarea {
    resize: none;
  }
</style>