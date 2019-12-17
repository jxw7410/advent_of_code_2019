require_relative "day9"
require "set"
require "byebug"

#some sort of dfs
class OxygenSystem
  attr_accessor :processor

  def initialize(processor)
    @processor = processor
    @visited = Hash.new
    @device_coord = []
  end

  def solve_part_one
    dfs(0, 0)
    @visited[[0, 0]]
  end

  def solve_part_two
    dfs(0, 0)
    bfs()
  end

  private

  def dfs(x, y, prev = nil)
    return @visited[[x, y]] if @visited.include?([x, y])
    @visited[[x, y]] = 0

    begin
      self.processor.process_instructions
    rescue => exception
      output = self.processor.output.pop
      return @visited[[x, y]] = -1 if output == 0
      if output == 2
        @device_coord = [x, y]
        return 0
      end

      self.processor.inputs << 1 unless @visited.include?([x, y + 1])
      p1 = dfs(x, y + 1, 1)

      self.processor.inputs << 2 unless @visited.include?([x, y - 1])
      p2 = dfs(x, y - 1, 2)

      self.processor.inputs << 3 unless @visited.include?([x - 1, y])
      p3 = dfs(x - 1, y, 3)

      self.processor.inputs << 4 unless @visited.include?([x + 1, y])
      p4 = dfs(x + 1, y, 4)

      backtrack(prev)
      @visited[[x, y]] = 1 + [p1, p2, p3, p4].max
    end

    @visited[[x, y]]
  end

  def backtrack(prev)
    case prev
    when 1
      i = 2
    when 2
      i = 1
    when 3
      i = 4
    when 4
      i = 3
    else
      i = nil
    end

    self.processor.inputs << i if i
    begin
      self.processor.process_instructions
    rescue => exception
      # do nothing...
    end
  end

  def bfs()
    visited = Set.new()
    queue = [@device_coord]
    minute = 0 
    until queue.empty?
      t_queue = []
      until queue.empty?
        x, y = queue.shift
        next if visited.include?([x, y])
        visited.add([x, y])
        t_queue << [x + 1, y] if @visited.include?([x + 1, y]) && @visited[[x + 1, y]] > -1
        t_queue << [x - 1, y] if @visited.include?([x - 1, y]) && @visited[[x - 1, y]] > -1
        t_queue << [x, y - 1] if @visited.include?([x, y - 1]) && @visited[[x, y - 1]] > -1
        t_queue << [x, y + 1] if @visited.include?([x, y + 1]) && @visited[[x, y + 1]] > -1
      end
      minute += 1
      queue.concat(t_queue)
    end

    minute
  end
end

f = File.open("day15.txt", "r")
input = f.first.split(",").map(&:to_i)
p1 = Processor.new(input, 0, false)
#p1.process_instructions

os = OxygenSystem.new(p1)
p os.solve_part_two
