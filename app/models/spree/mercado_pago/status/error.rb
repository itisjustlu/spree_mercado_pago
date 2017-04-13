class Spree::MercadoPago::Status::Error
  def initialize(response)
    @error = response["message"] || I18n.t("spree.mercadopago.gateway.#{response["status_detail"]}") || "Unexpected error"
  end

  def success?
    false
  end
  def authorization
    nil
  end

  def to_s
    @error
  end
end