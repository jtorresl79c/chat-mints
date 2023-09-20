<template>
    <div>
        <button class="btn btn-secondary d-none d-sm-block" type="button" @click.prevent="openModal">
            {{ locale == 'es' ? 'Iniciar sesión' : 'Login' }}
        </button>

      <Teleport to="body" :disabled="false">
        <LoginModal ref="loginModal"/>
      </Teleport>
    </div>
</template>
<script>
import LoginModal from './LoginModal.vue';

export default {
    inject: ['locale'],
    components: { LoginModal },
    methods: {
        openModal() {
            this.$refs.loginModal.show();
        }
    }
}
</script>