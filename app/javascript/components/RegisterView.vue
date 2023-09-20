<template>
    <div class="RegisterView bg-white d-flex justify-content-center align-items-center"
        style="height: 100vh; background-color: rgba(0, 0, 0, 0) !important;">

        
        <form action="" @submit.prevent="signup" class="bg-white p-5 shadow-sm bg-body-tertiary rounded" style="width: 450px;">
            <div>
                <div class="alert alert-danger alert-dismissible fade show" role="alert" v-for="error in errors" :key="error">
                    {{error}}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </div>

            <div class="mb-3">
                <label for="email" class="form-label">Email</label>
                <input type="text" class="form-control" id="email" placeholder="Email" v-model="email" required>
            </div>

            <div class="mb-3">
                <label for="given_name" class="form-label">Given Name</label>
                <input type="text" class="form-control" id="given_name" placeholder="Given Name" v-model="given_name" 
                    required>
            </div>

            <div class="mb-3">
                <label for="last_name" class="form-label">Last Name</label>
                <input type="text" class="form-control" id="last_name" placeholder="Last name" v-model="last_name" required>
            </div>

            <div class="mb-3">
                <label for="password" class="form-label">Password (Minimo 6 caracteres)</label>
                <input type="password" class="form-control" id="password" placeholder="Password" v-model="password" required
                pattern=".{6,}">
            </div>

            <div>
                <button class="btn btn-primary w-100">Create Account</button>
            </div>

        </form>
        <Loading v-if="loading" />
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
    name: "RegisterView",
    data: () => ({
        email: '',
        last_name: '',
        given_name: '',
        password: '',
        loading: false,
        errors: []
    }),
    methods: {
        async signup() {
            console.log('dsad1')
            this.loading = true
            try {
                const { data } = await this.$axios.post(apiEndpoint + '/register',
                {
                    email: this.email,
                        password: this.password,
                        last_name: this.last_name,
                        given_name: this.given_name
                    }
                )
                console.log(data)
                localStorage.setItem('sessionToken', data.session_token)
                this.$store.commit('setSessionToken', data.session_token)
                this.$router.push({ name: 'principal' })
            } catch (error) {
                console.error(error.response.data)
                const errors = error.response.data
                
                // console.log(undefined?.email)
                if(errors?.email){
                    this.errors.push(errors.email[0])
                }

                if(errors?.password){
                    this.errors.push(errors.password[0])
                }
                
                

            } finally {
                this.loading = false
            }
            
            // this.$axios.get('/posts/1')
            // .then((json) => console.log(json));

            // this.$router.push({name: 'principal'})
        }


    },
}
</script>

<style scoped></style>