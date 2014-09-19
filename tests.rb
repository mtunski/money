require './task_1.rb'
require 'minitest/autorun'

class Task1Test < Minitest::Test
  def setup
    @money = Money.new(10, 'USD')
  end

  def teardown
  end

  def test_money_initialization
    assert_equal 10, @money.value
    assert_equal 'USD', @money.currency
  end

  def test_money_to_str
    assert_equal '10.00 USD', @money.to_s
  end
end
