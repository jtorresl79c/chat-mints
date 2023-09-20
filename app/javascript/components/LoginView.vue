<template>
    <div class="LoginPage bg-white d-flex justify-content-center align-items-center" style="height: 100vh; background-color: rgba(0, 0, 0, 0) !important;">

        <div class="bg-white p-5 shadow-sm bg-body-tertiary rounded">
            <form action="" @submit.prevent="goToPrincipal">
    
                <div class="mb-3">
                    <label for="email" class="form-label">Email</label>
                    <input type="email" class="form-control" id="email" placeholder="Email" v-model="email">
                </div>
    
                <div class="mb-3">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" class="form-control" id="password" placeholder="Password" v-model="password">
                </div>
    
                <div>
                    <button class="btn btn-primary w-100 mb-3">Ingresar</button>
                    <p>Don't have an account? <span class="text-info pointer" @click="goToSignUp">Sign up</span></p>
                </div>
            </form>

            <Loading v-if="loading"/>
        </div>


    </div>
</template>

<script>
import Loading from './Loading.vue'

import config from '../config.json';
const apiEndpoint = config.apiEndpoint
export default {
    inject: [
        "$axios"
    ],
    components: {
        Loading
    },
    name: "LoginView",
    data: () => ({
        test: 'Hola',
        email: "",
        password: "",
        loading: false
    }),
    created () {
        // this.$store.getters.sessionToken 

        // if(!this.$store.getters.sessionToken){
        //     this.$store.commit('setSessionToken', )
        // }
    },
    mounted() {
        // ajax
    },
    methods: {
        async goToPrincipal() {
            console.log(apiEndpoint + '/login')
            this.loading = true
            try {
                const {data} = await this.$axios.post(apiEndpoint + '/login', {email: this.email, password: this.password})
                localStorage.setItem('sessionToken', data.session_token)
                this.$store.commit('setSessionToken', data.session_token)
                this.$router.push({name: 'principal'})
            } catch (error) {
                alert("Login error")
            }finally {
                this.loading = false
            }

            

            // this.$axios.post(apiEndpoint + '/login', {email: this.email, password: this.password})
            //     .then((json) => console.log(json));
        },

        goToSignUp(){
            this.$router.push({name: 'register'})
        }


    },
}
</script>

<style scoped>
.pointer{
    cursor: pointer;
    text-decoration: underline;
}
</style>