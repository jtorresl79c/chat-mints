<template>
    <div>
        <!-- {{ counter }}
        <button class="btn btn-primary" @click="increment">Dashboard</button> -->
        <div class="router-view">
            <RouterView />
        </div>
        
    </div>
</template>

<script>
    export default {
        data: function(){
            return {
                test: "Hola mundo",
                counter: 0
            }
        },
        methods: {
            increment() {
                console.log(this.$router)
            }
        },
        computed: {
            getToken() {
                return this.$store.getters.getSessionToken
            }
        },
        
    }
</script>

<style scoped>

</style>