require 'money/exchange'

class Money
  include Comparable

  attr_accessor :value, :currency

  @exchange = Exchange.new

  def initialize(value, currency=self.class.default_currency)
    raise ArgumentError, 'Currency not set!' if currency.nil?

    @value, @currency = value, currency
  end

  def method_missing(method)
    if method.to_s =~ /^to_(.+)$/
      currency = method.to_s.split('_')[1]

      raise NoMethodError, "No method #{method} - currency '#{currency}' unsupported"
    end

    super
  end

  Exchange.currencies.each do |currency|
    define_method("to_#{currency}") do
      exchange_to(currency)
    end
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
    exchange_to(money.currency).to_d <=> money.value.to_d
  end

  def +(money)
    self.class.new(@value + money.exchange_to(@currency).value, @currency)
  end

  def -(money)
    self.class.new(@value - money.exchange_to(@currency).value, @currency)
  end

  def *(number)
    self.class.new(@value * number, @currency)
  end

  def /(number)
    self.class.new(@value / number, @currency)
  end

  class << self
    attr_reader :exchange, :default_currency

    Exchange.currencies.each do |currency|
      define_method("from_#{currency}") do |value|
        new(value, currency.upcase)
      end
    end

    def using_default_currency(currency)
      begin
        temp_currency     = @default_currency
        @default_currency = currency

        yield
      ensure
        @default_currency = temp_currency
      end
    end
  end
end

def Money(*args)
  Money.new(*args)
end
