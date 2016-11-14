# base on https://en.wikipedia.org/wiki/Conway%27s_Game_of_Lif://en.wikipedia.org/wiki/Conway%27s_Game_of_Life
require 'minitest/autorun'

class GameOfLifeTest < Minitest::Test
  def iterate(arr)
    new_arr = []

    arr.each do |row|
      new_arr << row.dup
    end

    (0...arr.size).each do |i|
      (0...arr.size).each do |j|
        lives_count = 0

        minx = max(i - 1, 0)
        maxx = min(arr.size - 1, i + 1)

        miny = max(j - 1, 0)
        maxy = min(arr.size - 1, j + 1)

        (minx..maxx).each do |x|
          (miny..maxy).each do |y|
            if !(x == i && y == j)
              if arr[x][y] == 1
                lives_count += 1
              end
            end
          end
        end

        if arr[i][j] == 1 && lives_count < 2
          new_arr[i][j] = 0
        end

        if arr[i][j] == 1 && lives_count > 3
          new_arr[i][j] = 0
        end

        if arr[i][j] == 0 && lives_count == 3
          new_arr[i][j] = 1
        end
      end
    end

    new_arr
  end

  def max(a, b)
    a > b ? a : b
  end

  def min(a, b)
    a < b ? a : b
  end

  def game(arr, times = 5)
    a = arr

    times.times.each do
      system("clear")
      display(a)
      a = iterate(a)
      sleep(0.5)
    end
  end

  def display(arr)
    arr.each do |row|
      puts row.join(",")
    end
  end


  def assert_die_at(x, y, arr)
    next_generation_arr = iterate(arr)
    assert_equal(0, next_generation_arr[x][y])
  end

  def assert_live_at(x, y, arr)
    next_generation_arr = iterate(arr)
    assert_equal(1, next_generation_arr[x][y])
  end

  def test_die_because_less_than_two_neighbor_die
    arr = [
      [1, 0],
      [0, 0]
    ]

    assert_die_at(0, 0, arr)
  end

  def test_die_because_less_than_two_neighbor_die2
    arr = [
      [0, 0],
      [1, 0]
    ]

    assert_die_at(0, 1, arr)
  end

  def test_die_because_less_than_two_neighbor_die3
    arr = [
      [0, 0],
      [0, 1]
    ]

    assert_die_at(1,1,arr)
  end

  def test_die_because_more_than_3_die_neighbor
    arr = [
      [1, 0, 0],
      [0, 1, 1],
      [1, 1, 0],
    ]

    assert_die_at(1, 1, arr)
  end

  def test_live_because_reproduction
    arr = [
      [1, 0, 0],
      [0, 1, 1],
      [1, 1, 0],
    ]

    assert_live_at(2, 2, arr)
  end

  def test_live
    assert_live_at(0, 0, [[1,1], [1,1]])
    assert_live_at(1, 1, [[1,1], [1,1]])
    assert_live_at(1, 0, [[1,1], [1,1]])
    assert_live_at(0, 1, [[1,1], [1,1]])

    boat = [
      [0,0,0,0,0],
      [0,1,1,0,0],
      [0,1,0,1,0],
      [0,0,1,0,0],
      [0,0,0,0,0]
    ]

    assert_live_at(1, 1, boat)
  end

  def test_transform
    beacon = [
      [0,0,0,0,0,0,0],
      [0,1,1,0,0,0,0],
      [0,1,0,0,0,0,0],
      [0,0,0,0,1,0,0],
      [0,0,0,1,1,0,0],
      [0,0,0,0,0,0,0],
    ]

    assert_live_at(2, 2, beacon)
    assert_live_at(3, 3, beacon)
    #game beacon, 10 # unccoment to see

    blinker = [
      [0,0,0,0,0],
      [0,0,1,0,0],
      [0,0,1,0,0],
      [0,0,1,0,0],
      [0,0,0,0,0],
    ]

    #game(blinker, 10) # uncomment this to see the movement
  end
end
