<template>
  <div>
    <div class="d-flex justify-content-end">
      <button type="submit" @click.prevent="submit" :disabled="submitStatus" :class="buttonField?.extra_parameters?.styles || 'btn btn-success'">
        <span v-if="submitStatus" class="spinner-border text-light spinner-border-sm mx-1" role="status"></span>
        {{ buttonField?.help }}
      </button>
    </div>

    <div class="d-flex justify-content-end" v-if="buttonField?.extra_parameters?.help_text">
      <span class=""> {{ buttonField.extra_parameters.help_text }} </span>
    </div>
  </div>
</template>
<script>
// Store
import { dynamicFormStore } from "../../stores/store";
import { mapStores, mapState } from 'pinia'

export default {
    methods: {
        submit() {
            this.$emit('submit')
        }
    },
  computed: {
      ...mapStores(dynamicFormStore),
      ...mapState(dynamicFormStore, ['buttonField', 'submitStatus'])
  }
}
</script>