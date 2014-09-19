require './exchange'

class Money
  attr_accessor :value, :currency

  @exchange = Exchange.new

  def initialize(value, currency)
    @value, @currency = value, currency
  end

  def to_s
    "#{format('%.2f', value)} #{currency}"
  end

  def inspect
    "#<#{self.class} #{to_s}>"
  end

  def exchange_to(currency)
    self.class.exchange.convert(self, currency)
  end

  class << self
    attr_accessor :exchange

    %w(usd eur gbp).each do |currency|
      define_method("from_#{currency}") do |value|
        new(value, currency.upcase)
      end
    end
  end
end

def Money(value, currency)
  Money.new(value, currency)
end
