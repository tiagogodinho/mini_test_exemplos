require 'minitest/autorun'
require File.expand_path('../../lib/calculator', __FILE__)

class TestCalculator < MiniTest::Unit::TestCase
  def test_sum_two_numbers
    assert_equal 3, Calculator.sum(1, 2)
  end
end
