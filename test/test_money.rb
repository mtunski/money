require 'test_helper'
require 'money'

class MoneyTest < Minitest::Test
  def setup
    @money = Money.new(10, 'USD')

    stub_exchange_rates(Money.exchange)
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

  def test_money_to_s
    assert_equal '10.00 USD', @money.to_s
  end

  def test_money_inspect
    assert_equal '#<Money 10.00 USD>', @money.inspect
  end

  def test_money_from_currency
    assert_equal Money.new(10, 'USD').inspect, Money.from_usd(10).inspect
    assert_equal Money.new(10, 'EUR').inspect, Money.from_eur(10).inspect
    assert_equal Money.new(10, 'GBP').inspect, Money.from_gbp(10).inspect
    assert_equal Money.new(10, 'PLN').inspect, Money.from_pln(10).inspect
    assert_equal Money.new(10, 'CHF').inspect, Money.from_chf(10).inspect
    assert_equal Money.new(10, 'JPY').inspect, Money.from_jpy(10).inspect
  end

  def test_money_exchange_to
    assert_equal 12.253325246138672, Money(20, 'USD').exchange_to('GBP').value.to_f
    assert_equal 83.7204,            Money(20, 'EUR').exchange_to('PLN').value.to_f
    assert_equal 0,                  Money(0,  'EUR').exchange_to('PLN').value.to_f
    assert_equal 1,                  Money(1,  'EUR').exchange_to('EUR').value.to_f
  end

  def test_money_exchange_to_raises_exception_with_appropriate_message_when_currency_is_invalid
    err = assert_raises Exchange::InvalidCurrencyError do Money(20, 'GBP').exchange_to('') end
    assert_equal 'Please, provide both currencies', err.message

    err = assert_raises Exchange::InvalidCurrencyError do Money(20, '').exchange_to('GBP') end
    assert_equal 'Please, provide both currencies', err.message

    err = assert_raises Exchange::InvalidCurrencyError do Money(20, 'GBP').exchange_to('AAA') end
    assert_equal 'Invalid currency: AAA', err.message

    err = assert_raises Exchange::InvalidCurrencyError do Money(20, 'AAA').exchange_to('GBP') end
    assert_equal 'Invalid currency: AAA', err.message

    err = assert_raises Exchange::InvalidCurrencyError do Money(20, 'AAA').exchange_to('AAA') end
    assert_equal 'Invalid currency: AAA', err.message

    err = assert_raises Exchange::InvalidCurrencyError do Money(20, 'AAA').exchange_to('ZZZ') end
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
    res = case @money
          when Money(20, 'PLN')..Money(30, 'PLN') then 'fail'
          when Money(30, 'PLN')..Money(40, 'PLN') then 'OK'
          when Money(40, 'PLN')..Money(50, 'PLN') then 'fail'
          end

    assert_equal 'OK', res
  end

  def test_money_using_default_currency
    assert_equal Money(100, 'USD'), Money.using_default_currency('USD') { Money(100) }
    assert_equal Money(100, 'GBP'), (Money.using_default_currency('USD') do
                                      Money.using_default_currency('GBP') do
                                        Money(100)
                                      end
                                    end)
    assert_equal Money(100, 'USD'), (Money.using_default_currency('USD') do
                                      Money.using_default_currency('GBP') do
                                        Money(100)
                                      end

                                      Money(100)
                                    end)
  end

  def test_money_initialization_raises_exception_with_appropriate_message_when_no_currency_defined
    err = assert_raises ArgumentError do Money.new(100) end
    assert_equal 'Currency not set!', err.message

    err = assert_raises ArgumentError do Money(100) end
    assert_equal 'Currency not set!', err.message
  end

  def test_money_to_currency
    assert_equal 12.253325246138672, Money(20, 'USD').to_gbp.value.to_f
    assert_equal 83.7204,            Money(20, 'EUR').to_pln.value.to_f
    assert_equal 0,                  Money(0,  'EUR').to_pln.value.to_f
    assert_equal 1,                  Money(1,  'EUR').to_eur.value.to_f
  end

  def test_money_to_currency_raises_exception_with_appropriate_message_when_method_missing
    err = assert_raises NoMethodError do @money.to_aaa end
    assert_equal "undefined method `to_aaa' for #<Money 10.00 USD>", err.message

    err = assert_raises NoMethodError do @money.aaa end
    assert_equal "undefined method `aaa' for #<Money 10.00 USD>", err.message
  end

  def test_money_respond_to
    assert @money.respond_to? :to_eur
    refute @money.respond_to? :to_aaa
    refute @money.respond_to? :aaa
  end

  def test_money_arithmetics
    assert_equal Money(11.28421, 'USD'), @money + Money(1, 'EUR')
    assert_equal Money(8.71579,  'USD'), @money - Money(1, 'EUR')
    assert_equal Money(20,       'USD'), @money * 2
    assert_equal Money(5,        'USD'), @money / 2
  end
end
