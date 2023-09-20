class FirstTouch
  include Mongoid::Document
  include Mongoid::Timestamps

  field :phone, type: String
  field :first_touch, type: Boolean
end