
<!-- template for the modal component -->
<template>
  <transition name="modal">
    <div class="cali__modal-mask" role="dialog">
      <div class="cali__modal-dialog" role="document">
        <div class="cali__modal-content" :class="('size-' + modalSize)" :id="uniqueId">

          <div class="cali__modal-header">
            <slot name="header">
              <h4 class="cali__modal-title">{{ title || 'Default title' }}</h4>
            </slot>
            <button type="button" class="cali_modal-btn-close" @click="$emit('close')">
              <img class="cali__modal-close-modal" v-if="closeModalImage.src" :src="closeModalImage.src" :alt="closeModalImage.alt" />

              <span class="cali__modal-close-modal" v-else> x </span>
            </button>
          </div>

          <div class="cali__modal-body">
            <slot name="body">
              Default body
            </slot>
          </div>

          <div class="cali__modal-footer">
            <slot name="footer">
              <button type="button" class="cali__modal-btn-primary" @click="$emit('close')">OK</button>
              <button type="button" class="cali__modal-btn-secondary" @click="$emit('close')"><i class="fal fa-times"></i> Close</button>
            </slot>
          </div>
        </div>
      </div>
    </div>
  </transition>
</template>

<script>
export default {
  props: {
    closeModalImage: {
        type: Object,
        default: () => ({
            src: null,
            alt: null
        })
    },
    title: String,
    modalSize: {
      type: String,
      default: 'md'
    }
  },
  computed: {
    uniqueId() {
        return 'modal__' + this?.$?.type?.__scopeId + '__' + this?.$?.uid
    }
  },
  methods: {
    manageClick(e) {
        if (!document.getElementById(this.uniqueId).contains(e.target)){
            this.$emit('close');
        }
    }
  },
  created() {
    document.body.style.overflow='hidden';

    setTimeout(() => {
        window.addEventListener('click', this.manageClick, true);
    }, 250)
  },
  beforeUnmount() {
    document.body.style.overflow='';

    window.removeEventListener('click', this.manageClick, true);
  }
}
</script>

<style scoped>
@import "styles.css";
</style>
