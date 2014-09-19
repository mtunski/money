require './money'
require 'minitest/autorun'

class MoneyTest < Minitest::Test
  def setup
    @money = Money.new(10, 'USD')
  end

  def teardown
  end

  def test_money_initialization
    assert_equal 10,    @money.value
    assert_equal 'USD', @money.currency
  end

  def test_money_shorthand_initialization
    money = Money(20, 'PLN')

    assert_equal 20,    money.value
    assert_equal 'PLN', money.currency
  end

  def test_money_to_str
    assert_equal '10.00 USD', @money.to_s
  end

  def test_money_inspect
    assert_equal '#<Money 10.00 USD>', @money.inspect
  end

  def test_money_from_currency
    assert_equal '#<Money 10.00 USD>', Money.from_usd(10).inspect
    assert_equal '#<Money 10.00 EUR>', Money.from_eur(10).inspect
    assert_equal '#<Money 10.00 GBP>', Money.from_gbp(10).inspect
  end
end

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
    assert_equal 'Invalid currencies: ', err.message

    err = assert_raises Exchange::InvalidCurrency do @exchange.convert(Money(20, ''),    'GBP') end
    assert_equal 'Invalid currencies: ', err.message

    err = assert_raises Exchange::InvalidCurrency do @exchange.convert(Money(20, 'GBP'), 'AAA') end
    assert_equal 'Invalid currencies: AAA', err.message

    err = assert_raises Exchange::InvalidCurrency do @exchange.convert(Money(20, 'AAA'), 'GBP') end
    assert_equal 'Invalid currencies: AAA', err.message

    err = assert_raises Exchange::InvalidCurrency do @exchange.convert(Money(20, 'AAA'), 'AAA') end
    assert_equal 'Invalid currencies: AAA', err.message

    err = assert_raises Exchange::InvalidCurrency do @exchange.convert(Money(20, 'AAA'), 'ZZZ') end
    assert_equal 'Invalid currencies: AAA, ZZZ', err.message
  end
end
