class Api::WebhooksController < Api::ApiController

    require 'pusher'

    attr_accessor :pusher

    def initialize
        @pusher = Pusher::Client.new(
            app_id: '1673539',
            key: '16bed938d7ef38986c5d',
            secret: '2cb4f478e896867c52c5',
            cluster: 'us3',
            encrypted: true
        )
    end

    def created_message
        @pusher.trigger('my-channel', 'my-event', {
            message: 'hello world'
        })

        render json: "hola", status: 200
    end


end