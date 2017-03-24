class Spree::MercadoPago::Status::Success
  def success?
    true
  end

  def authorization
    nil
  end
end