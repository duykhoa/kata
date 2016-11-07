require 'minitest/autorun'

class AccendingArrTest < Minitest::Test
  def accarr(arr)
    if arr.size == 1
      return arr
    end

    pre_el = [-1] * arr.size
    length_arr = [0] * arr.size
    length_arr[0] = 1

    i = 1

    while i <= (arr.size - 1)
      j = i - 1

      while j >=0 && arr[j] > arr[i]
        j -= 1
      end

      pre_el[i] = j
      length_arr[i] = length_arr[j] + 1

      i += 1
    end

    final = 0

    (0..(arr.size - 1)).each do |i|
      if length_arr[i] > length_arr[final]
        final = i
      end
    end

    result = []

    while final >= 0
      result = result.unshift(arr[final])
      final = pre_el[final]
    end

    result
  end

  def test_accarr
    assert_equal([1], accarr([1]))
    assert_equal([2], accarr([2]))

    # 2 elements
    assert_equal([3], accarr([3, 2]))
    assert_equal([1, 2], accarr([1, 2]))

    # 3 elements
    assert_equal([1, 2, 3], accarr([1, 2, 3]))
    assert_equal([1, 2], accarr([1, 2, 0]))
    assert_equal([2, 3], accarr([5, 2, 3]))
    assert_equal([1, 4], accarr([1, 4, 3]))

    # 4 elements
    assert_equal([1, 2, 3, 4], accarr([1, 2, 3, 4]))
    assert_equal([1, 3, 4], accarr([1, 5, 3, 4]))
    assert_equal([2, 3, 4], accarr([5, 2, 3, 4]))

    assert_equal([1,2,5,7], accarr([4,1,2,5,7]))
    assert_equal([1,2,3,4,5,6], accarr([1,6,7,2,8,6,3,9,7,4,8,5,6]))
  end
end
