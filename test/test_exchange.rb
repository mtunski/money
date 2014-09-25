require 'test_helper'
require 'money/exchange'

class ExchangeTest < Minitest::Test
  def setup
    @exchange = Exchange.new
  end

  def test_exchange_convert
    stub_exchange_rates(@exchange)

    assert_equal 12.253325246138672, @exchange.convert(Money(20, 'USD'), 'GBP').value.to_f
    assert_equal 83.7204,            @exchange.convert(Money(20, 'EUR'), 'PLN').value.to_f
    assert_equal 0,                  @exchange.convert(Money(0,  'EUR'), 'PLN').value.to_f
    assert_equal 1,                  @exchange.convert(Money(1,  'EUR'), 'EUR').value.to_f
  end

  def test_exchange_convert_raises_exception_with_appropriate_message_when_currency_is_invalid
    stub_exchange_rates(@exchange)

    err = assert_raises Exchange::InvalidCurrencyError do @exchange.convert(Money(20, 'GBP'), '') end
    assert_equal 'Please, provide both currencies', err.message

    err = assert_raises Exchange::InvalidCurrencyError do @exchange.convert(Money(20, ''),    'GBP') end
    assert_equal 'Please, provide both currencies', err.message

    err = assert_raises Exchange::InvalidCurrencyError do @exchange.convert(Money(20, 'GBP'), 'AAA') end
    assert_equal 'Invalid currency: AAA', err.message

    err = assert_raises Exchange::InvalidCurrencyError do @exchange.convert(Money(20, 'AAA'), 'GBP') end
    assert_equal 'Invalid currency: AAA', err.message

    err = assert_raises Exchange::InvalidCurrencyError do @exchange.convert(Money(20, 'AAA'), 'AAA') end
    assert_equal 'Invalid currency: AAA', err.message

    err = assert_raises Exchange::InvalidCurrencyError do @exchange.convert(Money(20, 'AAA'), 'ZZZ') end
    assert_equal 'Invalid currency: AAA', err.message
  end

  def test_exchange_convert_raises_exception_with_appropriate_message_when_rates_not_fetched
    err = assert_raises Exchange::RateMissingError do @exchange.convert(Money(20, 'GBP'), 'PLN') end
    assert_equal 'You have to fetch the conversion rate before converting!', err.message
  end

  def test_exchange_fetch_rate
    assert_empty @exchange.rates

    @exchange.fetch_rate('USD', 'GBP')

    assert_equal 2, @exchange.rates.size
  end
end
