# day 3 of advent of code challenge of 2019

class NRange
  attr_reader :coord1, :coord2

  def initialize(coord1, coord2)
    @coord1, @coord2 = [coord1, coord2].sort
  end

  def orientation
    # row, col
    if self.coord1[0] == self.coord2[0]
      return "VERTICAL"
    elsif self.coord1[1] == self.coord2[1]
      return "HORIZONTAL"
    else
      raise "Coordinates error"
    end
  end

  def get_distance 
    (self.coord1[0] - self.coord2[0]).abs + (self.coord1[1] - self.coord2[1]).abs
  end
end

## Part 1

def find_manhatten_distance(wire1, wire2)
  ranges_1 = findWireRanges(wire1)
  ranges_2 = findWireRanges(wire2)

  intersect_points = []

  ranges_2.each do |range2|
    ranges_1.each do |range1|
      intersection = get_intersection(range1, range2)
      intersect_points.push(intersection) if intersection
    end
  end

  min = 1.0 / 0.0 #infinity
  intersect_points.each do |v1, v2|
    sum = v1.abs + v2.abs
    min = sum if sum < min
  end
  min
end

def get_intersection(range1, range2)
  if range1.orientation != range2.orientation
    if range1.orientation == "HORIZONTAL"
      return [range2.coord1[0], range1.coord1[1]] if is_intersect?(range1, range2)
    else
      return [range1.coord1[0], range2.coord1[1]] if is_intersect?(range1, range2)
    end
  end
end

def is_intersect?(range1, range2)
  case_1 = range1.coord1[1] < range2.coord1[1] && range2.coord1[1] < range1.coord2[1] && range2.coord1[0] < range1.coord1[0] && range1.coord1[0] < range2.coord2[0]
  case_2 = range1.coord1[0] < range2.coord1[0] && range2.coord1[0] < range1.coord2[0] && range2.coord1[1] < range1.coord1[1] && range1.coord1[1] < range2.coord2[1]
  case_1 || case_2
end

def findWireRanges(wire)
  r, c = 0, 0
  ranges = []
  wire.each do |ins|
    dir = ins[0]
    val = ins[1..-1].to_i
    case dir
    when "U"
      ranges.push(NRange.new([r, c], [r + val, c]))
      r += val
    when "D"
      ranges.push(NRange.new([r, c], [r - val, c]))
      r -= val
    when "L"
      ranges.push(NRange.new([r, c], [r, c - val]))
      c -= val
    when "R"
      ranges.push(NRange.new([r, c], [r, c + val]))
      c += val
    end
  end

  ranges
end

## Part 2

class Intersection
  attr_reader :coord, :range1, :range2

  def initialize(coord, range1, range2)
    @coord = coord
    @range1 = range1
    @range2 = range2
  end
end

def find_min_steps(wire1, wire2)
  ranges_1 = findWireRanges(wire1)
  ranges_2 = findWireRanges(wire2)
  intersections = []

  ranges_2.each do |range2|
    ranges_1.each do |range1|
      intersection = get_intersection_and_ranges(range1, range2)
      intersections.push(intersection) if intersection
    end
  end

  min_steps = []

  intersections.each do |intersection|
    step1 = calculate_min_steps(intersection.coord, intersection.range1, ranges_1)
    step2 = calculate_min_steps(intersection.coord, intersection.range2, ranges_2)
    min_steps.push(step1 + step2)
  end
  return min_steps.min
end

def calculate_min_steps(coord, target_range, range_set)
  i = 0
  total = 0

  until target_range == range_set[i]
    total += range_set[i].get_distance
    i += 1
  end

  t_range = range_set[i - 1]

  if [t_range.coord1, t_range.coord2].include? target_range.coord1
    total += (target_range.coord1[0] - coord[0]).abs + (target_range.coord1[1] - coord[1]).abs
  else 
    total += (target_range.coord2[0] - coord[0]).abs + (target_range.coord2[1] - coord[1]).abs
  end

  total
end

def get_intersection_and_ranges(range1, range2)
  if range1.orientation != range2.orientation
    if range1.orientation == "HORIZONTAL"
      return Intersection.new([range2.coord1[0], range1.coord1[1]], range1, range2) if is_intersect?(range1, range2)
    else
      return Intersection.new([range1.coord1[0], range2.coord1[1]], range1, range2) if is_intersect?(range1, range2)
    end
  end
end
