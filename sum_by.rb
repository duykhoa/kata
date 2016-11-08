require 'minitest/autorun'

class SumByTest < Minitest::Test
  def sum_by(n)
    if n == 1
      n
    else
      result = []
      result << [1, n - 1]

      if n > 2
        sum_by(n-1).each do |sol|
          result << [1] + sol
        end
      end

      result
    end
  end

  def assert_sum_by_include(n, sol)
    assert_equal(true, sum_by(n).include?(sol))
  end

  def test_sum_by
    assert_equal(1, sum_by(1))
    assert_equal([[1, 1]], sum_by(2))

    assert_sum_by_include(3, [1, 1, 1])

    assert_sum_by_include(4, [1, 3])
    assert_sum_by_include(4, [1, 1, 1, 1])
    assert_sum_by_include(4, [1, 1, 2])
    puts sum_by(10).inspect
  end
end
