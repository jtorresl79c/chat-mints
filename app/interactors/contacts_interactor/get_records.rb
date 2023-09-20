module ContactsInteractor
  # Join a conversation with other group of contacts
  class GetRecords
    include Interactor
    include FiltersHelper

    before do
      @sdk = context.sdk
      @params = context.params
    end

    def call
      contacts = sdk.get_contacts(get_options)
      context.fail!(error: "CXF has failed.") unless contacts['data']

      context.payload = contacts
    end

    private

    attr_reader :sdk, :payload, :params

    def get_options
      get_base_filters(@params.except(:controller, :action))
    end

  end
end
