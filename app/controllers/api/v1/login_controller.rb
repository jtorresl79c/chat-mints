class Api::V1::LoginController < Api::ApiController
    def contact_send_magic_link
        login_result = AuthInteractor::ViaMagicLink.call(
          params: params,
          sdk: @mints_contact
        )

        return return_custom_error(login_result.error) if login_result.failure?
        render json: { data: 'success' }
    end

    def check_email
        result = ContactsInteractor::VerifyExistingEmail.call(
          params: params,
          sdk: @mints_user,
          template_slug: 'contact-magic-link'
        )

        return return_custom_error(result.error) if result.failure?

        render json: { data: result.payload }
    end

end
  