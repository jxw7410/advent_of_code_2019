require_relative "day9"
require "set"
require "byebug"

#some sort of dfs
class OxygenSystem
  attr_accessor :processor

  def initialize(processor)
    @processor = processor
    @visited = Hash.new
  end

  def solve_part_one
    dfs(0, 0)
    @visited[[0, 0]]
  end

  private

  def dfs(x, y)
    return @visited[[x, y]] if @visited.include?([x, y])
    @visited[[x, y]] = 1 / 0.0

    begin
      self.processor.process_instructions
    rescue => exception
      output = self.processor.output.pop
      return 1 / 0.0 if output == 0
      return 0 if output == 2

      self.processor.inputs << 1 unless @visited.include?([x, y + 1])
      p1 = dfs(x, y + 1)

      self.processor.inputs << 2 unless @visited.include?([x, y - 1])
      p2 = dfs(x, y - 1)

      self.processor.inputs << 3 unless @visited.include?([x - 1, y])
      p3 = dfs(x - 1, y)

      self.processor.inputs << 4 unless @visited.include?([x + 1, y])
      p4 = dfs(x + 1, y)

      @visited[[x, y]] = 1 + [p1, p2, p3, p4].min
    end

    @visited[[x, y]]
  end
end

f = File.open("day15.txt", "r")
input = f.first.split(",").map(&:to_i)
p1 = Processor.new(input, 0, false)
#p1.process_instructions

os = OxygenSystem.new(p1)
p os.solve_part_one
