<template>
  <div class="cali__workflow-card" v-if="items?.length > 0">
    <div class="cali__workflow-progress-bar">
      <div class="cali__workflow-progress-bar__filled" :style="progressBarWidth"></div>
    </div>

    <div class="cali__workflow-items-container">
      <div class="cali__workflow-item"
           :style="itemWidth"
           v-for="(item, index) in items" :key="'item_' + index + 1">
        <div class="cali__workflow-item__img" v-html="activeStep === index ? item.activeIconHTML : item.iconHTML"> </div>

        <div>
          <h6 v-html="item.title"></h6>
          <p v-html="typeof item.description === 'function' ? item.description() : item.description"></p>
        </div>
      </div>
    </div>
  </div>
</template>

<script>

export default {
  name: 'CaliWorkflow',
  props: {
    items: {
      type: Array,
      default: () => ([])
    },
    activeStep: {
      type: Number,
      default: 0
    }
  },
  computed: {
    itemWidth() {
      return 'width: ' + (100 / this.items?.length || 1) + '%;'
    },
    progressBarWidth() {
      let width = (100 / ( this.items?.length / (this.activeStep + 1) ));
      return ('width: ' + width + '% !important;') + (width === 100 ? 'border-radius: 1rem 1rem 0 0 !important;' : '')
    }
  }
}
</script>

<style scoped>
@import "styles.css";
</style>