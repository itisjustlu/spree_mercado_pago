class Spree::MercadoPago::Status::Error
  def initialize(error)
    @error = error
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