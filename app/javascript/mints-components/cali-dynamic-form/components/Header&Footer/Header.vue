<template>
    <h1 class="header__title"> {{ title }} </h1>
    <p class="header__description"> {{ description }} </p>
</template>
<script>
// Store
import { dynamicFormStore } from "../../stores/store";
import { mapStores, mapState } from 'pinia'
export default {
  computed: {
    ...mapStores(dynamicFormStore),
    ...mapState(dynamicFormStore, ['title', 'description'])
  }
}
</script>