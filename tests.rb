require './task_1.rb'
require 'minitest/autorun'

class Task1Test < Minitest::Test
  def setup
    @money = Money.new(10, 'USD')
  end

  def teardown
  end

  def test_money_initialization
    assert_equal @money.value, 10
    assert_equal @money.currency, 'USD'
  end
end
