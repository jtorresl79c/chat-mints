<template>
    <div>

    </div>
</template>

<script>
    export default {
       beforeCreate () {
        localStorage.removeItem('sessionToken')
        this.$router.push({name: 'login'})
       },
    }
</script>

<style lang="scss" scoped>

</style>