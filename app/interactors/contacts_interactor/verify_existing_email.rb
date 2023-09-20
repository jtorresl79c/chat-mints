module ContactsInteractor
  # Verify if the email exist in the CXF instance
  class VerifyExistingEmail
    include Interactor

    before do
      @sdk = context.sdk
      @params = context.params
    end

    def call
      data = get_data
      context.fail!(error: "No email provided") unless data[:email]

      contacts = @sdk.get_contacts({'filters[email]': data[:email] })['meta']

      context.payload = contacts && contacts['total'] > 0 ? 'email_exists' : 'email_not_exists'
    end

    private

    attr_reader :sdk, :payload, :params

    def get_data
      data = @params.require(:data).permit(:email).to_h
      data[:email] = ActiveSupport::Inflector.transliterate(data[:email].downcase.strip).to_s

      data
    end

  end
end
