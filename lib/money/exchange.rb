require 'open-uri'
require 'json'

class Exchange
  class InvalidCurrencyError < StandardError
    def initialize(currency)
      msg = currency.empty? ? 'Please, provide both currencies' : "Invalid currency: #{currency}"

      super(msg)
    end
  end

  RateFetchError   = Class.new(StandardError)
  RateMissingError = Class.new(StandardError)

  attr_accessor :rates
  class << self; attr_accessor :currencies end

  @currencies = %w(eur pln gbp usd chf jpy)

  def initialize
    @rates = {}
  end

  def convert(money, currency)
    raise InvalidCurrencyError, money.currency unless currency_supported?(money.currency)
    raise InvalidCurrencyError, currency       unless currency_supported?(currency)
    raise RateMissingError, 'You have to fetch the conversion rate before converting!' unless rate = rate(money.currency, currency)

    Money.new(money.value * rate, currency)
  end

  def fetch_rate(from, to)
    rates["#{from}_#{to}"] ||= begin
      uri      = "http://rate-exchange.appspot.com/currency?from=#{from}&to=#{to}"
      response = JSON.parse(open(uri).read)

      raise RateFetchError, 'An error occurred while fetching the rates from the server.' if response['err']

      @rates["#{to}_#{from}"] = 1 / response['rate']
      @rates["#{from}_#{to}"] = response['rate']
    end
  end

  private

  def rate(from, to)
    rates["#{from}_#{to}"] || rates["#{to}_#{from}"]
  end

  def currency_supported?(currency)
    self.class.currencies.include?(currency.downcase)
  end
end
