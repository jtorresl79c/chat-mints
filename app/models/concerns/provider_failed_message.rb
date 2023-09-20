class ProviderFailedMessage
  include Mongoid::Document
  include Mongoid::Timestamps

  field :provider, type: String
  field :destination, type: String
  field :message_id, type: String
  field :status, type: String
  field :type, type: String
  field :payload, type: String
  
end