require_relative "day9"
require "byebug"

=begin
  input value for processor is determined by color current block.
  safe to say if current block is not in hash, it is black, else white

=end
class PaintRobot
  attr_accessor :painted_count
  attr_reader :direction_index, :painted

  DIRECTION = [
    "UP",
    "RIGHT",
    "DOWN",
    "LEFT",
  ]

  DIRECTION_DELTA = {
    "UP" => [-1, 0],
    "DOWN" => [1, 0],
    "RIGHT" => [0, 1],
    "LEFT" => [0, -1],
  }

  def initialize(processor)
    @processor = processor
    @direction_index = 0
    @pos = [0, 0]
    @painted = Hash.new
    @painted_count = 0
  end

  def direction
    PaintRobot::DIRECTION[self.direction_index]
  end

  def run
    terminate_program = false

    @processor.inputs << 1 #loading the predetermined first input
    until terminate_program
      begin
        @processor.process_instructions
        terminate_program = true
      rescue => error
        rotation_code = @processor.output.pop
        color_code = @processor.output.pop
        update_cursor(color_code, rotation_code)
        @processor.inputs << (@painted.include?(@pos) ? @painted[@pos] : 0)
      end
    end
    @painted_count
  end

  def set_direction(rotation)
    if rotation.to_i == 0
      @direction_index = (@direction_index - 1) % 4
    elsif rotation.to_i == 1
      @direction_index = (direction_index + 1) % 4
    end
  end

  private

  def update_cursor(color_code, rotation_code)
    self.painted_count += 1 unless @painted.include?(@pos)
    @painted[@pos] = color_code.to_i
    set_direction(rotation_code)
    update_pos()
  end

  def update_pos
    dy, dx = PaintRobot::DIRECTION_DELTA[self.direction]
    @pos = [@pos[0] + dy, @pos[1] + dx]
  end
end

f = File.open("day11.txt", "r")
input = f.first.split(",").map(&:to_i)

p0 = Processor.new(input)
p1 = Processor.new(input, 0, false)

# p0.process_instructions
# r1 = PaintRobot.new(p1)
# p r1.run

# part II
def render_number(input)
  p1 = Processor.new(input, 0, false)
  r1 = PaintRobot.new(p1)
  r1.run
  grid = Array.new(6){ Array.new(41, 0)} #hard coded grid based on the input
  for row in 0..5 
    for col in 0..40 
      grid[row][col] = r1.painted[[row, col]] if r1.painted.include?([row, col])
    end
  end

  grid.each{|row| p row}
end

render_number(input)