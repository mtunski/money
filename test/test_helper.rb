require 'minitest/autorun'
require "mocha/mini_test"

def stub_exchange_rates(exchange)
  rates = {
    'EUR_EUR' => 1,
    'EUR_PLN' => 4.1860200000000001,
    'EUR_GBP' => 0.78663899999999998,
    'EUR_USD' => 1.2842100000000001,
    'EUR_CHF' => 1.2069399999999999,
    'EUR_JPY' => 139.82900000000001,

    'PLN_PLN' => 1,
    'PLN_EUR' => 1 / 4.1860200000000001,
    'PLN_GBP' => 0.188109,
    'PLN_USD' => 0.30696899999999999,
    'PLN_CHF' => 0.28841600000000001,
    'PLN_JPY' => 33.414700000000003,

    'GBP_GBP' => 1,
    'GBP_EUR' => 1 / 0.78663899999999998,
    'GBP_PLN' => 1 / 0.188109,
    'GBP_USD' => 1.6322099999999999,
    'GBP_CHF' => 1.5336399999999999,
    'GBP_JPY' => 177.63399999999999,

    'USD_USD' => 1,
    'USD_EUR' => 1 / 1.2842100000000001,
    'USD_PLN' => 1 / 0.30696899999999999,
    'USD_GBP' => 1 / 1.6322099999999999,
    'USD_CHF' => 0.93984500000000004,
    'USD_JPY' => 108.866,

    'CHF_CHF' => 1,
    'CHF_EUR' => 1 / 1.2069399999999999,
    'CHF_PLN' => 1 / 0.28841600000000001,
    'CHF_GBP' => 1 / 1.5336399999999999,
    'CHF_USD' => 1 / 0.93984500000000004,
    'CHF_JPY' => 115,

    'JPY_JPY' => 1,
    'EUR_JPY' => 1 / 139.82900000000001,
    'PLN_JPY' => 1 / 33.414700000000003,
    'GBP_JPY' => 1 / 177.63399999999999,
    'USD_JPY' => 1 / 108.866,
    'CHF_JPY' => 1 / 115
  }

  exchange.stubs(:rates).returns(rates)
end
