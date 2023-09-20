module Api
    class ApiController < Mints::BaseApiController
        skip_before_action :verify_authenticity_token
        before_action :check_api_key, except: [:magic_link_login,:user_magic_link_login] # todo lo que esta en before_action funciona como middleware

        def check_api_key
            app_api_key = ENV["API_KEY"] ? ENV["API_KEY"] : '9c6334a7-8215-46ff-8ec9-f442cdc43cac'
            @api_key = request.headers[:HTTP_X_API_KEY]

            render json: {status: "Unauthorized"} if @api_key.nil? || @api_key != app_api_key
        end

        def magic_link_login
            hash = params[:hash]
            mints_contact_magic_link_login(hash)
        end

        def user_magic_link_login
            hash = params[:hash]
            mints_user_magic_link_login(hash)
        end

        # Return custom error to ui
        # @param message [String]
        # @return [void]
        def return_custom_error(message)
            render json: { message: message }, status: :bad_request
        end
    end
end