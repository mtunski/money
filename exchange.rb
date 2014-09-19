class Exchange
  class InvalidCurrency < StandardError
  end

  def convert(money, currency)
    currencies = %w(eur pln gbp usd chf jpy)

    rates = {
      eur_eur: 1,
      pln_pln: 1,
      gbp_gbp: 1,
      usd_usd: 1,
      chf_chf: 1,
      jpy_jpy: 1,
      eur_pln: 4.1860200000000001,
      eur_gbp: 0.78663899999999998,
      eur_usd: 1.2842100000000001,
      eur_chf: 1.2069399999999999,
      eur_jpy: 139.82900000000001,
      pln_gbp: 0.188109,
      pln_usd: 0.30696899999999999,
      pln_chf: 0.28841600000000001,
      pln_jpy: 33.414700000000003,
      gbp_usd: 1.6322099999999999,
      gbp_chf: 1.5336399999999999,
      gbp_jpy: 177.63399999999999,
      usd_chf: 0.93984500000000004,
      usd_jpy: 108.866,
      chf_jpy: 115.85899999999999
    }

    conversion          = "#{money.currency.downcase}_#{currency.downcase}".to_sym
    conversion_inverted = "#{currency.downcase}_#{money.currency.downcase}".to_sym

    if rates[conversion]
      rate = rates[conversion]
    elsif rates[conversion_inverted]
      rate = 1 / rates[conversion_inverted]
    else
      invalid_currencies = []
      invalid_currencies << money.currency unless currencies.include?(money.currency.downcase)
      invalid_currencies << currency       unless currencies.include?(currency.downcase)
      invalid_currencies = invalid_currencies.uniq

      raise InvalidCurrency, "Invalid currencies: #{invalid_currencies.join(', ')}"
    end

    rate * money.value
  end
end
