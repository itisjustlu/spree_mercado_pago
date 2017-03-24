require 'mercadopago.rb'

class Spree::MercadoPago::Gateways::CreditCard < Spree::Gateway
  def supports?(source)
    true
  end

  def source
    true
  end

  def provider_class
    ::MercadoPago
  end

  def provider
    ::MercadoPago.new(Rails.application.try(:secrets).try(:[], :mercado_pago).try(:[], "access_token"))
  end

  def auto_capture?
    true
  end

  def method_type
    'mercado_pago_credit_card'
  end

  def payment_source_class
    ::Spree::MercadoPago::Payments::CreditCard
  end

  def purchase(amount, express_checkout, gateway_options={})

    data = {
      description: "",
      transaction_amount: express_checkout.collected_amount.to_f,
      token: express_checkout.token,
      installments: express_checkout.installments,
      payment_method_id: express_checkout.p_method_id,
      statement_descriptor: "",
      payer: {
          email: gateway_options[:email]
      }
    }

    result = provider.post("/v1/payments", data)

    if result["status"] == "201" && result["response"]["id"].present? && result["response"]["status"] == "approved"
      express_checkout.update({gateway_object_id: result["response"]["id"], data: result["response"], email: gateway_options[:email]})
      ::Spree::MercadoPago::Status::Success.new
    else
      ::Spree::MercadoPago::Status::Error.new(I18n.t("spree.mercadopago.gateway.#{result["response"]["status_detail"]}") || "Error inesperado")
    end
  end

  def parse_installments(installments)
    sprintf '%02d', installments.to_s
  end

  def refund(payment, amount)
    refund_type = payment.amount == amount.to_f ? "Full" : "Partial"
    refund_transaction = provider.build_refund_transaction({
                                                               :TransactionID => payment.source.transaction_id,
                                                               :RefundType => refund_type,
                                                               :Amount => {
                                                                   :currencyID => payment.currency,
                                                                   :value => amount },
                                                               :RefundSource => "any" })
    refund_transaction_response = provider.refund_transaction(refund_transaction)
    if refund_transaction_response.success?
      payment.source.update_attributes({
                                           :refunded_at => Time.now,
                                           :refund_transaction_id => refund_transaction_response.RefundTransactionID,
                                           :state => "refunded",
                                           :refund_type => refund_type
                                       })

      payment.class.create!(
          :order => payment.order,
          :source => payment,
          :payment_method => payment.payment_method,
          :amount => amount.to_f.abs * -1,
          :response_code => refund_transaction_response.RefundTransactionID,
          :state => 'completed'
      )
    end
    refund_transaction_response
  end
end