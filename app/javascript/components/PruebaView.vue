<template>
    <div>
        <p>Hola mundo</p>
        <ul>
            <li v-for="message in messages">
                {{ message }}
            </li>
        </ul>
    </div>
</template>

<script>
import Pusher from 'pusher-js';
export default {
    data() {
        return {
            messages: []
        }
    },
    mounted () {
        // Enable pusher logging - don't include this in production
        const self = this
        Pusher.logToConsole = true;

        var pusher = new Pusher('16bed938d7ef38986c5d', {
            cluster: 'us3'
        });

        var channel = pusher.subscribe('my-channel');
        channel.bind('my-event', function(data) {
            self.messages.push(JSON.stringify(data.message));
        });

    },
}
</script>

<style scoped></style>