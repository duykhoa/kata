require 'minitest/autorun'

class SumByTest < Minitest::Test
  def sum_by(n, s = 1)
    result = []

    if n == s
      result << [n]
    else
      (s..n/2).each do |i|
        result << [i, n - i]

        if (n-i) > i
          sum_by(n-i, i).each do |sol|
            result << [i] + sol
          end
        end
      end

      result
    end
  end

  def assert_sum_by_include(n, sol)
    assert_equal(true, sum_by(n).include?(sol))
  end

  def display_result(n)
    result = sum_by(n)

    result.map { |x| puts x.join(',')}
    printf "total sol: %d\n" % result.size
  end

  def test_sum_by
    assert_equal([[1]], sum_by(1))
    assert_equal([[1, 1]], sum_by(2))

    assert_sum_by_include(3, [1, 1, 1])

    assert_sum_by_include(4, [1, 3])
    assert_sum_by_include(4, [1, 1, 1, 1])
    assert_sum_by_include(4, [1, 1, 2])
    assert_sum_by_include(4, [2, 2])
    assert_sum_by_include(5, [2, 3])

    display_result(10)
    display_result(20)
    display_result(50)
  end
end
