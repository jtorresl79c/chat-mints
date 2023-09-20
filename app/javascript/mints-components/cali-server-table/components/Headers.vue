<template>
  <thead class="thead-light">
  <tr>
    <th v-for="(header, index) in headers" class="data-header" :key="'header_' + index" v-html="header"></th>
  </tr>
  </thead>
</template>

<script>
export default {
  props: {
    headers: {
      type: Object,
      required: true
    }
  }
}
</script>