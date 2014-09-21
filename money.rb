require './exchange'

class Money
  include Comparable

  attr_accessor :value, :currency

  @exchange = Exchange.new

  def initialize(value, currency=self.class.default_currency)
    raise ArgumentError, 'Currency not set!' if currency.nil?

    @value, @currency = value, currency
  end

  def to_s
    "#{format('%.2f', value)} #{currency}"
  end

  def to_int
    @value
  end

  def inspect
    "#<#{self.class} #{to_s}>"
  end

  def exchange_to(currency)
    self.class.exchange.convert(self, currency)
  end

  def <=>(money)
    exchange_to(money.currency) <=> money.value
  end

  class << self
    attr_reader :exchange, :default_currency

    %w(usd eur gbp).each do |currency|
      define_method("from_#{currency}") do |value|
        new(value, currency.upcase)
      end
    end

    def using_default_currency(currency)
      @default_currency = currency

      yield

      @default_currency = nil
    end
  end
end

def Money(value, currency=Money.default_currency)
  Money.new(value, currency)
end
