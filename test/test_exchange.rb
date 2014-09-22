require 'test_helper'
require 'money/exchange'

class ExchangeTest < Minitest::Test
  def setup
    @exchange = Exchange.new
  end

  def teardown
  end

  def test_exchange_convert
    mock_rates(@exchange)

    assert_equal 12.25332524613867, @exchange.convert(Money(20, 'USD'), 'GBP').to_f
    assert_equal 83.7204,           @exchange.convert(Money(20, 'EUR'), 'PLN').to_f
    assert_equal 0,                 @exchange.convert(Money(0,  'EUR'), 'PLN').to_f
    assert_equal 1,                 @exchange.convert(Money(1,  'EUR'), 'EUR').to_f
  end

  def test_exchange_convert_raises_exception_with_appropriate_message_when_currency_is_invalid
    mock_rates(@exchange)

    err = assert_raises Exchange::InvalidCurrency do @exchange.convert(Money(20, 'GBP'), '') end
    assert_equal 'Please, provide both currencies', err.message

    err = assert_raises Exchange::InvalidCurrency do @exchange.convert(Money(20, ''),    'GBP') end
    assert_equal 'Please, provide both currencies', err.message

    err = assert_raises Exchange::InvalidCurrency do @exchange.convert(Money(20, 'GBP'), 'AAA') end
    assert_equal 'Invalid currency: AAA', err.message

    err = assert_raises Exchange::InvalidCurrency do @exchange.convert(Money(20, 'AAA'), 'GBP') end
    assert_equal 'Invalid currency: AAA', err.message

    err = assert_raises Exchange::InvalidCurrency do @exchange.convert(Money(20, 'AAA'), 'AAA') end
    assert_equal 'Invalid currency: AAA', err.message

    err = assert_raises Exchange::InvalidCurrency do @exchange.convert(Money(20, 'AAA'), 'ZZZ') end
    assert_equal 'Invalid currency: AAA', err.message
  end

  def test_exchange_convert_raises_exception_with_appropriate_message_when_rates_not_fetched
    err = assert_raises Exchange::RatesMissingError do @exchange.convert(Money(20, 'GBP'), '') end
    assert_equal 'You have to fetch the conversion rates before converting!', err.message
  end

  def test_exchange_fetch_rates
    assert_nil @exchange.rates

    @exchange.fetch_rates

    assert_kind_of Hash, @exchange.rates
    assert_equal   21,   @exchange.rates.size
  end
end
