require 'minitest/autorun'

class SumDigitsTest < Minitest::Test
  def factorial(n)
    if n < 2
      1
    else
      (1..n).inject(1) { |s,i| s * i }
    end
  end

  def sum_digits(n)
    s = 0

    while n > 0
      s = s + n % 10
      n = n / 10
    end

    s
  end

  def test_factorial
    assert_equal(1, factorial(0))
    assert_equal(2, factorial(2))
    assert_equal(6, factorial(3))
    assert_equal(24, factorial(4))
  end

  def test_sum_digits
    assert_equal(1, sum_digits(1))
    assert_equal(1, sum_digits(10))

    assert_equal(2, sum_digits(11))

    assert_equal(1, sum_digits(100))
    assert_equal(1, sum_digits(1000))
  end
end
