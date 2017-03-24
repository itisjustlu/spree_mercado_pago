class Spree::MercadoPago::Payments::CreditCard < Spree::MercadoPago::Base
  def self.table_name_prefix
    "spree_mercado_pago_payments_"
  end
end
