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

  def test_money_exchange_to
    assert_equal 12.25332524613867, Money(20, 'USD').exchange_to('GBP')
    assert_equal 83.7204,           Money(20, 'EUR').exchange_to('PLN')
    assert_equal 0,                 Money(0,  'EUR').exchange_to('PLN')
    assert_equal 1,                 Money(1,  'EUR').exchange_to('EUR')
  end

  def test_money_exchange_to_raises_exception_with_appropriate_message_when_currency_is_invalid
    err = assert_raises Exchange::InvalidCurrency do Money(20, 'GBP').exchange_to('') end
    assert_equal 'Invalid currencies: ', err.message

    err = assert_raises Exchange::InvalidCurrency do Money(20, '').exchange_to('GBP') end
    assert_equal 'Invalid currencies: ', err.message

    err = assert_raises Exchange::InvalidCurrency do Money(20, 'GBP').exchange_to('AAA') end
    assert_equal 'Invalid currencies: AAA', err.message

    err = assert_raises Exchange::InvalidCurrency do Money(20, 'AAA').exchange_to('GBP') end
    assert_equal 'Invalid currencies: AAA', err.message

    err = assert_raises Exchange::InvalidCurrency do Money(20, 'AAA').exchange_to('AAA') end
    assert_equal 'Invalid currencies: AAA', err.message

    err = assert_raises Exchange::InvalidCurrency do Money(20, 'AAA').exchange_to('ZZZ') end
    assert_equal 'Invalid currencies: AAA, ZZZ', err.message
  end

  def test_money_comparisons
    assert Money(20, 'PLN') == Money(20, 'PLN')
    assert Money(10, 'PLN') >= Money(1,  'USD')
    assert Money(20, 'PLN') >  Money(2,  'USD')
    assert Money(20, 'JPY') <= Money(90, 'EUR')
    assert Money(20, 'PLN') <  Money(50, 'USD')
    assert Money(20, 'PLN').between?(Money(1, 'EUR'), Money(30, 'PLN'))
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
