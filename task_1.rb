class Money
  attr_accessor :value, :currency

  def initialize(value, currency)
    @value, @currency = value, currency
  end
end
