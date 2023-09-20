<template>
    <div class="container flex-column flex-lg-row justify-content-center gap-3 bg-white d-flex align-items-center" style="min-height: 100vh; background-color: rgba(0, 0, 0, 0) !important;">
        
        <div>
            <p class="w-100 text-center">Ayuda</p>
            <img class="img-fluid flex-1" :src="imageHelp" alt="">
        </div>

        <div>
            <p class="w-100 text-center">Soporte tecnico</p>
            <img class="img-fluid" :src="imageSupport" alt="">
        </div>

        <div>
            <p class="w-100 text-center">Chat</p>
            <img class="img-fluid" :src="imageChat" alt="">
        </div>

    </div>
</template>

<script>
import imageChat from "../assets/img/chat.png"
import imageSupport from "../assets/img/support.png"
import imageHelp from "../assets/img/help.png"
    export default {
        data() {
            return {
                imageSupport,
                imageChat,
                imageHelp
            }
        },
    }
</script>

<style lang="scss" scoped>

</style>