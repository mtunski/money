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
    assert_equal 'Please, provide both currencies', err.message

    err = assert_raises Exchange::InvalidCurrency do Money(20, '').exchange_to('GBP') end
    assert_equal 'Please, provide both currencies', err.message

    err = assert_raises Exchange::InvalidCurrency do Money(20, 'GBP').exchange_to('AAA') end
    assert_equal 'Invalid currency: AAA', err.message

    err = assert_raises Exchange::InvalidCurrency do Money(20, 'AAA').exchange_to('GBP') end
    assert_equal 'Invalid currency: AAA', err.message

    err = assert_raises Exchange::InvalidCurrency do Money(20, 'AAA').exchange_to('AAA') end
    assert_equal 'Invalid currency: AAA', err.message

    err = assert_raises Exchange::InvalidCurrency do Money(20, 'AAA').exchange_to('ZZZ') end
    assert_equal 'Invalid currency: AAA', err.message
  end

  def test_money_comparisons
    assert Money(20, 'PLN') == Money(20, 'PLN')
    assert Money(10, 'PLN') >= Money(1,  'USD')
    assert Money(20, 'PLN') >  Money(2,  'USD')
    assert Money(20, 'JPY') <= Money(90, 'EUR')
    assert Money(20, 'PLN') <  Money(50, 'USD')
    assert Money(20, 'PLN').between?(Money(1, 'EUR'), Money(30, 'PLN'))
  end


  def test_money_in_case_statement
    res = case Money(10, 'USD')
          when Money(20, 'PLN')..Money(30, 'PLN') then 'fail'
          when Money(30, 'PLN')..Money(40, 'PLN') then 'OK'
          when Money(40, 'PLN')..Money(50, 'PLN') then 'fail'
          end

    assert_equal 'OK', res
  end

  def test_money_using_default_currency
    Money.using_default_currency('USD') do
      assert_equal Money.new(100, 'USD'), Money.new(100)
      assert_equal     Money(100, 'USD'),     Money(100)

      Money.using_default_currency('EUR') do
        assert_equal Money.new(100, 'EUR'), Money.new(100)
        assert_equal     Money(100, 'EUR'),     Money(100)
      end

      # assert_equal Money.new(100, 'USD'), Money.new(100)
      # assert_equal     Money(100, 'USD'),     Money(100)
    end
  end

  def test_money_initialization_raises_exception_with_appropriate_message_when_no_currency_defined
    err = assert_raises ArgumentError do Money.new(100) end
    assert_equal 'Currency not set!', err.message

    err = assert_raises ArgumentError do Money(100) end
    assert_equal 'Currency not set!', err.message
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
