require 'minitest/autorun'

class Calculator
  def self.sum(number_one, number_two)
    number_one + number_two
  end
end

class TestCalculator < MiniTest::Unit::TestCase
  def test_sum_two_numbers
    assert_equal 3, Calculator.sum(1, 2)
  end
end
