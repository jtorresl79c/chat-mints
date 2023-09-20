module Api
  module V1::Settings
    class LoginController < Api::V1::Settings::BaseController

      skip_before_action :verify_user

      def login_password
        login_result = AuthInteractor::ViaPassword.call(
          request: request,
          sdk: @mints_user
        )

        return return_custom_error(login_result.error) if login_result.failure?
        render json: { data: 'success' }
      end

      def magic_link_login
        login_result = AuthInteractor::ViaMagicLink.call(
          params: params,
          sdk: @mints_user
        )

        return return_custom_error(login_result.error) if login_result.failure?
        render json: { data: 'success' }
      end
    end
  end
end
