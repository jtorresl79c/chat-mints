class Coupon
  include Mongoid::Document
  include Mongoid::Timestamps

  field :phone, type: String
  field :coupons, type: Array
end