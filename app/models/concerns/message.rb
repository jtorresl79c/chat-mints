class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  field :phone, type: String
  field :type, type: String
  field :payload, type: String
end