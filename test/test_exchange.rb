require 'test_helper'
require 'money/exchange'

class ExchangeTest < Minitest::Test
  def setup
    @exchange = Exchange.new
  end

  def teardown
  end

  def test_exchange_convert
    assert_equal 12.25332524613867, @exchange.convert(Money(20, 'USD'), 'GBP')
    assert_equal 83.7204,           @exchange.convert(Money(20, 'EUR'), 'PLN')
    assert_equal 0,                 @exchange.convert(Money(0,  'EUR'), 'PLN')
    assert_equal 1,                 @exchange.convert(Money(1,  'EUR'), 'EUR')
  end

  def test_exchange_convert_raises_exception_with_appropriate_message_when_currency_is_invalid
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
end
