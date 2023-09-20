class Api::LoginController < Api::ApiController
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


    def define_mints_clients
        ["contact", "pub", "service_account"] 
    end

    def login
        data = login_verify_params
        status = 200
        begin
            payload = @mints_contact.login(data[:email],data[:password])

            # Mints::Errors::ValidationException
            # Mints::Errors::AccessDeniedException
        rescue Mints::Errors::AccessDeniedException => exception
            payload = exception.response
            status = 404
            # byebug
        end
        render json: payload, status: status

    end
    
    def register
        begin
            data = register_verify_params
            byebug
            contact_exists = self.check_if_contact_exists(data)
            if !contact_exists
                payload = @mints_contact.register(data)
                contact_email = payload["contact"]["email"]
                contact_id = self.get_user_by_email(contact_email)["id"]
                @mints_service_account.update_contact(contact_id, { is_email_verified: true })
                render json: payload, status: 200
            else
                render json: {"email" => ["El correo ya existe"]}, status: 406
            end
        rescue Mints::Errors::ValidationException => exception
            render json: exception.response, status: 406
        end

    end

    def create_random_user


        data = {
            email: get_random_username + "_random_#{params[:type]}@mints.cloud",
            password: "123456",
            given_name: "Random",
            last_name: "Mints User"
        }
        # byebugk
        payload = @mints_contact.register(data)
        contact_email = payload["contact"]["email"]
        contact_id = self.get_user_by_email(contact_email)["id"]
        @mints_service_account.update_contact(contact_id, { is_email_verified: true })
        render json: payload, status: 200
    end


    def get_random_username
        string_length = 8
        rand(36**string_length).to_s(36)
    end  

    def check_if_contact_exists(data)
        # payload = @mints_service_account.get_contacts({'filters[email]': params[:email]})
        payload = @mints_service_account.get_contacts({'filters[email]': data["email"]})
        payload["meta"]["total"] > 0
    end

    def get_user_by_email(email)
        payload = @mints_service_account.get_contacts({'filters[email]': email})
        payload["data"][0]
    end

    def prueba
        # @mints_contact.login("jason13@mints.cloud","123456")
        # contact = @mints_contact.me["data"]
        # hashvar = { "uno" => 1, "dos" => 2, "tres" => 3 }

        # byebug
        # payload = @mints_contact.get_conversations

        ########
        # data = {
        #     title: 'New Conversation To Test 4',
        #     conversation_template_id: 1,
        #     # contacts: [contact["id"]]
        # }

        # payload = @mints_contact.create_conversation(data)
        
        
        # payload["data"]["id"]
        # contact["id"]


        # data2 = {
        #     contact_id: 1269
        # }
        # payload = @mints_service_account.attach_contact_in_conversation(62, data2) # conversation_id, contact_id


        data = {
            conversation_id: 62,
            type: 'text',
            sender_type: "User",
            sender_id: 1,
            value: {
                text: 'Message Text millenium2'
            }
        }
        payload = @mints_service_account.create_message(data)

        # pusher = Pusher::Client.new(
        #     app_id: '1673539',
        #     key: '16bed938d7ef38986c5d',
        #     secret: '2cb4f478e896867c52c5',
        #     cluster: 'us3',
        #     encrypted: true
        # )

        # @pusher.trigger('my-channel', 'my-event', {
        #     message: 'hello world'
        # })

        render json: payload, status: 200
          
    end


    private

    def login_verify_params
        params.permit(:email, :password).to_h
    end

    def register_verify_params
        params.permit(:email, :given_name, :last_name, :password).to_h
    end
end