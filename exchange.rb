class Exchange
  class InvalidCurrency < StandardError
    def initialize(currency)
      msg = currency.empty? ? 'Please, provide both currencies' : "Invalid currency: #{currency}"

      super(msg)
    end
  end

  attr_accessor :rates

  def initialize
    @rates = {
      'eur_eur' => 1,
      'pln_pln' => 1,
      'gbp_gbp' => 1,
      'usd_usd' => 1,
      'chf_chf' => 1,
      'jpy_jpy' => 1,
      'eur_pln' => 4.1860200000000001,
      'eur_gbp' => 0.78663899999999998,
      'eur_usd' => 1.2842100000000001,
      'eur_chf' => 1.2069399999999999,
      'eur_jpy' => 139.82900000000001,
      'pln_gbp' => 0.188109,
      'pln_usd' => 0.30696899999999999,
      'pln_chf' => 0.28841600000000001,
      'pln_jpy' => 33.414700000000003,
      'gbp_usd' => 1.6322099999999999,
      'gbp_chf' => 1.5336399999999999,
      'gbp_jpy' => 177.63399999999999,
      'usd_chf' => 0.93984500000000004,
      'usd_jpy' => 108.866,
      'chf_jpy' => 115.85899999999999
    }
  end

  def convert(money, currency)
    conversion          = "#{money.currency.downcase}_#{currency.downcase}"
    conversion_inverted = "#{currency.downcase}_#{money.currency.downcase}"

    if rates[conversion]
      rate = rates[conversion]
    elsif rates[conversion_inverted]
      rate = 1 / rates[conversion_inverted]
    else
      raise InvalidCurrency, currency_supported?(money.currency) ? currency : money.currency
    end

    rate * money.value
  end

  private

  def currency_supported?(currency)
    @rates.each_key do |key|
      currency_1, currency_2 = key.split('_')

      break if currency_1 != currency_2
      return true if currency_1 == currency.downcase
    end

    false
  end
end
