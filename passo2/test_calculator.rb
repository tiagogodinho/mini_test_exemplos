require 'minitest/autorun'
require './calculator'

class TestCalculator < MiniTest::Unit::TestCase
  def test_sum_two_numbers
    assert_equal 3, Calculator.sum(1, 2)
  end
end
