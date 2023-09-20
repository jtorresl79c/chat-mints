module AuthInteractor
  extend ActiveSupport::Concern

  # User/Contact login via password
  class ViaPassword
    include Interactor

    before do
      @sdk = context.sdk
      @request = context.request
      @days = (context.days || 1).to_i
      @cookie = (context.cookie || 'mints_user_session_token').to_sym
    end

    def call
      data = get_data
      context.fail!(error: "No email/password provided") unless data['email'] and data['password']

      # Login in mints
      response = @sdk.login(data['email'], data['password'])

      context.fail!(error: "Wrong credentials") unless response['api_token']

      # Get session token from response
      session_token = response['api_token']
      # Set a permanent cookie with the session token
      cookies[@cookie] = { value: session_token, secure: true, httponly: true, expires: @days.day }

      context.payload = session_token
    end

    def request
      @request
    end

    private

    attr_reader :sdk, :payload, :params

    def get_data
      data = @request.params.except('controller', 'action').with_indifferent_access['data']
      data[:email] = ActiveSupport::Inflector.transliterate(data['email'].downcase.strip).to_s

      data
    end

  end
end
