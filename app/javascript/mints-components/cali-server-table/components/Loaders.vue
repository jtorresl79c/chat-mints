<template>
  <tr v-for="index in size" :key="'object_' + index">
    <td class="text-sm font-weight-normal" v-for="key in keys" :key="key">
      <div class='inner-card animate-pulse'></div>
    </td>
  </tr>
</template>

<script>
export default {
  props: {
    size: { type: Number, default: 10 },
    keys: { type: Array, default: () => ([]) },
  }
}
</script>