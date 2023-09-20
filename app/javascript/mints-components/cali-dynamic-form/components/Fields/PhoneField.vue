<template>
  <input v-if="field?.readonly || field?.extra_parameters?.readonly"
    :value="phone"
    readonly
    type="text"
    class="input-type-1 py-0"
    :id="`enum_${field.data_type_enum}`"/>

  <div v-else :class="{'error': hasError}">
    <MazPhoneNumberInput
      v-model="phone"
      :error="hasError"
      :no-example="true"
      :default-country-code="'MX'"
      :translations="{ phoneInput: { placeholder: field.help }, countrySelector: { placeholder: ''}}"
      @update="updatePhone"
      @keyup.enter="submit"/>

    <label class="general-register__paragraph error_message text-start" v-if="include_error_message && hasError"> {{field.validation_text}} </label>
  </div>
</template>

<script>
import MazPhoneNumberInput from 'maz-ui/components/MazPhoneNumberInput'
import 'maz-ui/css/main.css';

export default {
  inject: ['submit', 'include_error_message'],
  components: { MazPhoneNumberInput },
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
    }
  },
  data: () => ({
    type: 'mobile',
    countryCode: '+52',
    country: '',
    number: '',
    maskedNumber: '',
    phone: ''
  }),
  methods: {
    updatePhone(data){
      this.localValue = {
        number: data.nationalNumber,
        country: data.countryCode,
        fullNumber: data.e164,
        countryCode: "+" + data.countryCallingCode,
        maskedNumber: data.formatInternational
      }
    }
  },
  created() {
    if (this.modelValue?.number) {
      this.phone = this.modelValue.number
    }
  }
}
</script>

<style lang="scss" scoped>
@import '../../styles/errors';

</style>

<style lang="scss">
.error {
  .m-phone-number-input__input {
    background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 12 12' width='12' height='12' fill='none' stroke='%23dc3545'%3e%3ccircle cx='6' cy='6' r='4.5'/%3e%3cpath stroke-linejoin='round' d='M5.8 3.6h.4L6 6.5z'/%3e%3ccircle cx='6' cy='8.2' r='.6' fill='%23dc3545' stroke='none'/%3e%3c/svg%3e");
    background-repeat: no-repeat;
    background-position: right calc(.375em + .1875rem) center;
    background-size: calc(.75em + .375rem) calc(.75em + .375rem)
  }
}

.maz-rounded-lg {
  border-radius: 0 !important;
  border: 0!important;
  background-color: #74BEE0 !important;
  color: #fff !important;
  border-bottom: 1px solid #fff !important;
}

.m-input-input {
  color: #fff !important;
}

.maz-text-normal {
  color: #fff;
}
</style>