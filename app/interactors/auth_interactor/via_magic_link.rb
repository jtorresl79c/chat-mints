module AuthInteractor
  # Send magic link via the sdk
  class ViaMagicLink
    include Interactor

    before do
      @sdk = context.sdk
      @params = context.params
      @redirect_url = context.redirect_url || '/'
      @life_time = context.life_time || 24
      @max_visits = context.max_visits
      @template_id_or_slug = context.template_id || context.template_slug || '/'
    end

    def call
      data = get_data
      context.fail!(error: "No email provided") unless data[:email]

      # Login in mints
      data = { email: data[:email], redirectUrl: @redirect_url, lifeTime: @life_time, templateId: @template_id_or_slug }

      if @sdk.class.to_s.include? 'User'
        response = @sdk.client.raw(
          "post",
          "/users/magic-link",
          nil,
          { data: data }.to_json,
          '/api/v1'
        )
      else
        response = @sdk.send_magic_link(
          data[:email],
          @template_id_or_slug,
          @redirect_url,
          @life_time,
          @max_visits
        )
      end

      context.fail!(error: "Server error") unless response['success']

      context.payload = response
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
