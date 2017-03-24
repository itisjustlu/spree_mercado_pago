require 'spree_core'

module SpreeMercadoPago
  class Engine < Rails::Engine

    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_mercado_pago'

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../../app/**/*_decorator*.rb")) do |c|
        Rails.application.config.cache_classes ? require(c) : load(c)
      end

      Dir.glob(File.join(File.dirname(__FILE__), "../../app/overrides/*.rb")) do |c|
        Rails.application.config.cache_classes ? require(c) : load(c)
      end
    end

    initializer "spree_payment_network.register.payment_methods" do |app|
      app.config.spree.payment_methods += [Spree::MercadoPago::Gateways::CreditCard]
      app.config.assets.precompile += %w( spree/payments/mercado_pago_credit_card.js )
    end

    Spree::PermittedAttributes.source_attributes.push :token, :installments, :collected_amount, :p_method, :p_method_id, :doc_type, :doc_number, :last_four
  end
end
