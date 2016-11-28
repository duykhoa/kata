# base on https://en.wikipedia.org/wiki/Conway%27s_Game_of_Lif://en.wikipedia.org/wiki/Conway%27s_Game_of_Life
require 'minitest/autorun'

class GameOfLifeTest < Minitest::Test
  def iterate(arr)
    new_arr = arr.inject([]) do |r, row|
      r << row.dup
    end

    (0...arr.size).each do |x|
      (0...arr.size).each do |y|
        if arr[x][y] == 1 && live_neighbor_count(x,y,arr) < 2
          new_arr[x][y] = 0
        end

        if arr[x][y] == 1 && live_neighbor_count(x,y,arr) > 3
          new_arr[x][y] = 0
        end

        if arr[x][y] == 0 && live_neighbor_count(x,y,arr) == 3
          new_arr[x][y] = 1
        end
      end
    end

    new_arr
  end

  def live_neighbor_count(x, y, arr)
    minx = max(x - 1, 0)
    miny = max(y - 1, 0)

    maxx = min(x + 1, arr.size - 1)
    maxy = min(y + 1, arr.size - 1)

    live_count = 0

    (minx..maxx).each do |i|
      (miny..maxy).each do |j|
        if arr[i][j] == 1 && !(i == x && j == y)
          live_count += 1
        end
      end
    end

    live_count
  end

  def min(a, b)
    a < b ? a : b
  end

  def max(a, b)
    a > b ? a : b
  end

  def assert_live(x, y, input_arr)
    assert_stage(1, x, y, input_arr)
  end

  def assert_die(x, y, input_arr)
    assert_stage(0, x, y, input_arr)
  end

  def assert_stage(st, x, y, input_arr)
    result = iterate(input_arr)
    assert_equal(st, result[x][y])
  end

  def test_iterate
    arr = [[1]]
    assert_die(0, 0, arr)

    arr = [
      [1, 1],
      [1, 0],
    ]

    assert_live(0, 0, arr)

    arr = [
      [0, 0],
      [1, 1],
    ]

    assert_die(1, 1, arr)

    arr = [
      [1, 0, 0],
      [1, 0, 1],
      [1, 1, 1],
    ]

    assert_die(0, 0, arr)

    arr = [
      [1, 0, 0],
      [1, 1, 1],
      [1, 1, 1],
    ]

    assert_die(1, 1, arr)

    arr = [
      [0, 0, 0],
      [1, 0, 1],
      [0, 1, 0],
    ]

    assert_live(1, 1, arr)

    input_arr = [
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 1, 1, 1, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
    ]

    output_arr = [
      [0, 0, 0, 0, 0],
      [0, 0, 1, 0, 0],
      [0, 0, 1, 0, 0],
      [0, 0, 1, 0, 0],
      [0, 0, 0, 0, 0],
    ]

    assert_equal(output_arr, iterate(input_arr))

    input_arr = [
      [0, 0, 0, 0, 0],
      [0, 1, 1, 0, 0],
      [0, 1, 0, 0, 0],
      [0, 0, 0, 0, 1],
      [0, 0, 0, 1, 1],
    ]

    output_arr = [
      [0, 0, 0, 0, 0],
      [0, 1, 1, 0, 0],
      [0, 1, 1, 0, 0],
      [0, 0, 0, 1, 1],
      [0, 0, 0, 1, 1],
    ]

    assert_equal(output_arr, iterate(input_arr))
  end
end
