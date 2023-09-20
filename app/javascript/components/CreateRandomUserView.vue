<template>
    <div>
        <!-- <button class="btn btn-primary" @click="create">Coco</button> -->
        <Loading v-if="loading"/>
    </div>
</template>

<script>
import config from '../config.json';
const apiEndpoint = config.apiEndpoint
import Loading from './Loading.vue'
export default {
    data() {
        return {
            test: "dsdddd",
            loading: false
        }
    },
    inject: [
        "$axios"
    ],
    components: {
        Loading
    },
    mounted() {
        this.create()
    },
    methods: {
        async create() {
            const type = this.$route.params.type
            
            const allowed = ['support', 'chat', 'help']
            
            if(!type || !(allowed.includes(type))){
                this.$router.replace({name: "qrview"})
                return
            }

            const isLogged = !!this.$store.getters.getSessionToken

            if(isLogged){
                console.log('Ya logueado, reedireccionando a chat deseado')
                this.$router.replace({name: 'chatview', params: { type }})
                return
            }



            this.loading = true
            try {
                const {data} = await this.$axios.post(apiEndpoint + '/createrandomuser', {type})
                console.log(data)

                localStorage.setItem('sessionToken', data.session_token)
                this.$store.commit('setSessionToken', data.session_token)
                this.$router.replace({name: 'chatview', params: { type }})
                // alert('se puedo')
            } catch (error) {
               console.log(error)
            }finally {
                this.loading = false
            }
            

        }
    },
}
</script>

<style scoped></style>