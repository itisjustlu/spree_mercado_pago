class Spree::MercadoPago::Payments::Ticket < ApplicationRecord
  serialize :data, Hash
  belongs_to :user, class_name: "Spree::User"
  has_one :payment, class_name: "Spree::Payment", as: :source

  def self.table_name
    "spree_mercado_pago_payments_tickets"
  end
end
