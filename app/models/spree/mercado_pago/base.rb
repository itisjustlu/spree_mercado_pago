class Spree::MercadoPago::Base < ApplicationRecord
  serialize :data, Hash
  belongs_to :user, class_name: "Spree::User"
  belongs_to :payment, class_name: "Spree::Payment"
end