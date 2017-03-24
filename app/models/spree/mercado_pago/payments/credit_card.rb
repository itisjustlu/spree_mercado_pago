class Spree::MercadoPago::Payments::CreditCard < Spree::MercadoPago::Base
  def self.table_name
    "spree_mercado_pago_payments_credit_cards"
  end
end
