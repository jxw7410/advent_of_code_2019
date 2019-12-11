require "set"
# to monitor asteroids

def find_best_location(asteroid_field)
  res = 0
  coord = []
  get_asteroid_coordinates(asteroid_field).each do |row, col|
    t = bfs_asteroid_field(asteroid_field, row, col)
    if t > res
      res = t
      coord = [col, row]
    end
  end
  return res, coord
end

def get_asteroid_coordinates(asteroid_field)
  coordinates = []
  for row in 0...asteroid_field.length
    for col in 0...asteroid_field.first.length
      coordinates << [row, col] if asteroid_field[row][col] == "#"
    end
  end
  coordinates
end

def bfs_asteroid_field(asteroid_field, initial_row, initial_col)
  @asteroid_field = asteroid_field
  @visited = Set.new([@asteroid_field.first.length * initial_row + initial_col])
  @count = 0
  @initial_row = initial_row
  @initial_col = initial_col
  @queue = [[initial_row, initial_col]]

  def check_coordinates(row, col)
    key = @asteroid_field.first.length * row + col
    return if row < 0 || row == @asteroid_field.length || col < 0 || col == @asteroid_field.first.length || @visited.include?(key)
    @visited.add(key)
    if @asteroid_field[row][col] == "#"
      @count += 1
      delta_y, delta_x = get_deltas(row, col)
      set_blocked_asteroids(row + delta_y, col + delta_x, delta_y, delta_x)
    end
    @queue << [row, col]
  end

  def get_deltas(row, col)
    r1 = row - @initial_row
    c1 = col - @initial_col

    if @initial_row == row # vertical
      return 0, c1 > 0 ? 1 : -1
    elsif @initial_col == col # horizontal
      return r1 > 0 ? 1 : -1, 0
    elsif r1.abs == c1.abs # diagonals
      return r1 > 0 ? 1 : -1, c1 > 0 ? 1 : -1
    else
      gcd = euclid_gcd(r1.abs, c1.abs)
      return r1, c1 if gcd == 1
      until r1 % gcd != 0 || c1 % gcd != 0
        r1 /= gcd
        c1 /= gcd
      end
      return r1, c1
    end
  end

  def set_blocked_asteroids(row, col, delta_y, delta_x)
    return if row < 0 || row >= @asteroid_field.length || col < 0 || col >= @asteroid_field.first.length
    key = @asteroid_field.first.length * row + col
    @visited.add(key)
    set_blocked_asteroids(row + delta_y, col + delta_x, delta_y, delta_x)
  end

  until @queue.empty?
    row, col = @queue.shift
    check_coordinates(row + 1, col)
    check_coordinates(row, col - 1)
    check_coordinates(row, col + 1)
    check_coordinates(row - 1, col)
  end
  @count
end

def euclid_gcd(a, b)
  return a if b == 0
  euclid_gcd(b, a % b)
end


map1 = '.#....#####...#..
##...##.#####..##
##...#...#.#####.
..#.....X...###..
..#.#.....#....##'.split("\n")

map2 = '.###..#......###..#...#
#.#..#.##..###..#...#.#
#.#.#.##.#..##.#.###.##
.#..#...####.#.##..##..
#.###.#.####.##.#######
..#######..##..##.#.###
.##.#...##.##.####..###
....####.####.#########
#.########.#...##.####.
.#.#..#.#.#.#.##.###.##
#..#.#..##...#..#.####.
.###.#.#...###....###..
###..#.###..###.#.###.#
...###.##.#.##.#...#..#
#......#.#.##..#...#.#.
###.##.#..##...#..#.#.#
###..###..##.##..##.###
###.###.####....######.
.###.#####.#.#.#.#####.
##.#.###.###.##.##..##.
##.#..#..#..#.####.#.#.
.#.#.#.##.##########..#
#####.##......#.#.####.'.split("\n")

#find_best_location(map2)

p vaporize_asteroids(map1, 37)