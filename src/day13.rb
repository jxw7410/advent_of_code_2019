require_relative "day9"

f = File.open("day13.txt", "r")
input = f.first.split(",").map(&:to_i)

def part_one(input)
  p1 = Processor.new(input, 0, false)
  p1.process_instructions

  i = 0
  output = p1.output
  tile_ids = []
  while i < output.length
    tile_ids << output[i + 2]
    i += 3
  end
  tile_ids.reduce(0) { |count, tile_id| count += tile_id == 2 ? 1 : 0 }
end

#p part_one(input)

def part_two(input)
  input[0] = 2
  p1 = Processor.new(input, 0, false)
  end_game = false
  until end_game
    begin
      p1.process_instructions()
      end_game = true
    rescue => exception
      grid = get_game_grid(p1.output)
      ball_coord = get_coord(grid, "ball")
      paddle_coord = get_coord(grid, "paddle")
      p1.inputs << get_direction(ball_coord, paddle_coord)
    end
  end

  visual_mode(get_game_grid(p1.output))
end

def visual_mode(grid)
  system "clear"
  grid.each { |row| p row }
  sleep(0.5)
end


def get_game_grid(output)
  grid = Array.new(24) { Array.new(42, 0) }
  i = 0
  while i < output.length
    x = output[i]
    y = output[i + 1]
    val = output[i + 2]
    grid[y][x] = val
    i += 3
  end
  grid
end

def get_coord(grid, obj)
  i = 0

  case obj
  when "ball"
    target = 4
  when "paddle"
    target = 3
  end

  grid.each_with_index do |row, row_idx|
    row.each_with_index { |col_val, col_index| return [row_idx, col_index] if col_val == target }
  end
end

def get_direction(ball_coord, paddle_coord)
  by, bx = ball_coord
  py, px = paddle_coord
  if px < bx
    return 1
  elsif px > bx
    return -1
  else
    return 0
  end
end

part_two(input)
