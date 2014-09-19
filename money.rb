class Money
  attr_accessor :value, :currency

  def initialize(value, currency)
    @value, @currency = value, currency
  end

  def to_s
    "#{'%.2f' % value} #{currency}"
  end

  def inspect
    "#<#{self.class} #{to_s}>"
  end

  class << self
    %w(usd eur gbp).each do |currency|
      define_method("from_#{ currency }") do |value|
        new(value, currency.upcase)
      end
    end
  end
end

def Money(value, currency)
  Money.new(value, currency)
end
