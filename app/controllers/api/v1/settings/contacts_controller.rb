module Api
  module V1::Settings
    class ContactsController < Api::V1::Settings::BaseController

      skip_before_action :verify_user

      def index
        contact_result = ContactsInteractor::GetRecords.call(
          sdk: @mints_user,
          params: params.permit!.to_h
        )

        return return_custom_error(contact_result.error) if contact_result.failure?

        render json: contact_result.payload
      end
    end
  end
end
