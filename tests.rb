require './money'
require 'minitest/autorun'

class MoneyTest < Minitest::Test
  def setup
    @money = Money.new(10, 'USD')
  end

  def teardown
  end

  def test_money_initialization
    assert_equal 10, @money.value
    assert_equal 'USD', @money.currency
  end

  def test_money_shorthand_initialization
    money = Money(20, 'PLN')

    assert_equal 20, money.value
    assert_equal 'PLN', money.currency
  end

  def test_money_to_str
    assert_equal '10.00 USD', @money.to_s
  end

  def test_money_inspect
    assert_equal '#<Money 10.00 USD>', @money.inspect
  end

  def test_money_from_currency
    value           = 10
    value_formatted = '%.2f' % value

    usd, eur, gbp = Money.from_usd(value), Money.from_eur(value), Money.from_gbp(value)

    assert_equal "#{value_formatted} USD", usd.to_s
    assert_equal "#{value_formatted} EUR", eur.to_s
    assert_equal "#{value_formatted} GBP", gbp.to_s
  end
end
