class Money
  attr_accessor :value, :currency

  def initialize(value, currency)
    @value, @currency = value, currency
  end

  def to_s
    "#{ '%.2f' % value } #{ currency }"
  end
end
