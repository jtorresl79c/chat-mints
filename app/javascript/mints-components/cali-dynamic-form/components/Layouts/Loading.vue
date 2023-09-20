<template>
  <div class="dynamic-animate-pulse dynamic-form-skeleton"></div>
</template>

<style lang="scss" scoped>
  // Loader
  .dynamic-form-skeleton {
    width: 100%;
    height: 50px;
    background-color: #eee;
  }
  @keyframes pulse {
    50% {
      opacity: .9;
    }
  }

  .dynamic-animate-pulse {
    animation: pulse 2s cubic-bezier(0.4, 5, 0.6, 5) infinite;
  }
</style>