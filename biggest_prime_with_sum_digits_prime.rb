require 'minitest/autorun'

class PrimeWithSumDigitsIsPrimeTest < Minitest::Test
  def is_prime?(n)
    i = 2
    is_prime = true

    while i * i <= n && is_prime = (n % i != 0)
      i += 1
    end

    is_prime
  end

  def find_max_prime_less_than(n)
    i = n
    while !is_prime?(i)
      i -= 1
    end

    i
  end

  def test_is_prime
    assert_equal(true, is_prime?(2))
    assert_equal(false, is_prime?(4))
    assert_equal(false, is_prime?(9))
    assert_equal(true, is_prime?(3))
    assert_equal(false, is_prime?(25))
    assert_equal(true, is_prime?(991))
  end

  def test_find_max_prime_less_than
    assert_equal(2,find_max_prime_less_than(2))
    assert_equal(3,find_max_prime_less_than(4))
    assert_equal(1999993,find_max_prime_less_than(2_000_000))
    assert_equal(19999999,find_max_prime_less_than(20_000_000))
    #assert_equal(1999999999999943,find_max_prime_less_than(2_000_000_000_000_000))
  end
end
