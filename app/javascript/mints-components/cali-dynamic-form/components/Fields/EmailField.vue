<template>
  <label class="general-register__paragraph align-self-start" v-if="field.help"> {{field.help}} </label>

  <div class="d-flex">
    <input v-model="email"
       type="text"
       class="input-type-1  bg-white-light"
       :class="{'error': hasError}"
       :id="`enum_${field.data_type_enum}`"
       :name="field.slug"
       :placeholder="field.placeholder"
       :readonly="readonly"
       @keyup="ignoreKey"
       @keyup.enter="submit"/>
    <label class="general-register__paragraph input-type-1 w-50" v-if="domain"> {{domain}} </label>
  </div>

  <label class="general-register__paragraph error_message text-start" v-if="include_error_message && hasError"> {{field.validation_text}} </label>
</template>
<script>
export default {
  inject: ['submit', 'include_error_message', '$contact'],
  props:{
    field: {
      type: Object
    },
    modelValue: {
      required: true
    },
    hasError: Boolean
  },
  data: () => ({
    email: null
  }),
  mounted() {
    if (this.$contact?.email) {
      this.email = this.$contact?.email.split('@')[0]
    }
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
    },
    domain() {
      return this.field?.extra_parameters?.domain
    }
  },
  watch: {
    email() {
      if (this.domain) {
        this.email = this.email.replaceAll('@', '')
        this.localValue = this.email + this.domain
      } else {
        this.localValue = this.email
      }
    }
  }
}
</script>

<style lang="scss" scoped>
@import '../../styles/errors';
textarea {
  resize: none;
}
.a {
  padding-block: clamp(8px, 1vw, 15px);
  margin-block: clamp(8px, 1vw, 15px);
}
</style>