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
    raise RatesMissingError, 'You have to fetch the conversion rates before converting!' unless @rates
    raise InvalidCurrency,   money.currency unless currency_supported?(money.currency)
    raise InvalidCurrency,   currency       unless currency_supported?(currency)

    conversion = "#{money.currency.downcase}_#{currency.downcase}"

    rate = get_rate(conversion)

    rate * money.value.to_d
  end

  def fetch_rates
    currencies  = self.class.currencies
    conversions = currencies.map { |c| [c, c] }.concat(currencies.combination(2).to_a)
    @rates      = {}

    conversions.each do |conversion|
      from, to = conversion[0], conversion[1]
      uri      = "http://rate-exchange.appspot.com/currency?from=#{from}&to=#{to}"
      response = open(uri).read

      raise RateFetchError, 'An error occurred while fetching the rates from the server.' if response =~ /err/

      @rates["#{from}_#{to}"] = response.slice(/\d+.\d+/)
    end

    @rates
  end

  private

  def currency_supported?(currency)
    self.class.currencies.include?(currency.downcase)
  end

  def get_rate(conversion)
    currencies          = conversion.split('_')
    conversion_inverted = "#{currencies[1]}_#{currencies[0]}"

    rates[conversion] ? rates[conversion].to_d : 1.to_d / rates[conversion_inverted].to_d
  end
end
