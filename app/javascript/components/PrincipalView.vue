<template>
    <div class="container">
        
        <button class="btn btn-danger" @click="() => this.$router.push({name: 'logout'})">Logout</button>

        <div class="d-flex w-100">
            <div class="d-flex justify-content-center flex-column align-items-center flex-grow-1">
                <IconSupport/>
                <button class="btn btn-primary w-25 mb-2" @click="() => this.$router.push({name: 'chatview', params: {type: 'help'}})">Ayuda</button>
            </div>

            <div class="d-flex justify-content-center flex-column align-items-center flex-grow-1">
                <IconUser/>
                <button class="btn btn-primary w-25 mb-2" @click="() => this.$router.push({name: 'chatview', params: {type: 'support'}})">Soporte técnico</button>
            </div>

            <div class="d-flex justify-content-center flex-column align-items-center flex-grow-1">
                <IconHelp/>
                <button class="btn btn-primary w-25 mb-2" @click="() => this.$router.push({name: 'chatview', params: {type: 'chat'}})">Chat</button>
            </div>
        </div>
        
        

    </div>
</template>

<script>
    import IconSupport from './IconSupport.vue'
    import IconUser from './IconUser.vue'
    import IconHelp from './IconHelp.vue'
    export default {
        components: {
            IconSupport,
            IconUser,
            IconHelp
        },
    }
</script>

<style lang="scss" scoped>

</style>