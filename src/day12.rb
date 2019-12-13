require "set"

class Moon
  attr_accessor :name, :velocity, :axis

  def initialize(name, axis = [0, 0, 0], velocity = [0, 0, 0])
    @name = name
    @velocity = velocity
    @axis = axis
  end

  def pos(axis)
    case axis
    when "x"
      return self.axis[0]
    when "y"
      return self.axis[1]
    when "z"
      return self.axis[2]
    else
      raise "Invalid axis."
    end
  end

  def get_velocity(axis)
    case axis
    when "x"
      return self.velocity[0]
    when "y"
      return self.velocity[1]
    when "z"
      return self.velocity[2]
    else
      raise "Invalid axis."
    end
  end

  def set_velocity(axis, val)
    case axis
    when "x"
      self.velocity[0] += val
    when "y"
      self.velocity[1] += val
    when "z"
      self.velocity[2] += val
    else
      raise "Invalid axis."
    end
  end

  def apply_gravity(moon)
    compare_axis("x", moon)
    compare_axis("y", moon)
    compare_axis("z", moon)
  end

  def apply_velocity()
    self.axis[0] += self.velocity[0]
    self.axis[1] += self.velocity[1]
    self.axis[2] += self.velocity[2]
  end

  def get_total_energy
    self.axis.reduce(0) { |j, val| j += val.abs } * self.velocity.reduce(0) { |j, val| j += val.abs }
  end

  private

  def compare_axis(axis, moon)
    unless self.pos(axis) == moon.pos(axis)
      set_velocity(axis, self.pos(axis) < moon.pos(axis) ? 1 : -1)
    end
  end
end

=begin
  Functions to solve the day's question
=end

def run_gravity_field(moons)
  moons.each do |moon1|
    moons.each do |moon2|
      next if moon1 == moon2
      moon1.apply_gravity(moon2)
    end
  end
  moons.each &:apply_velocity
end

def calculate_total_energy(moons)
  moons.reduce(0) { |totalJ, moon| totalJ += moon.get_total_energy }
end

def get_final_postions(moons, steps)
  i = 0
  while i < steps
    run_gravity_field(moons)
    i += 1
  end
end

def solve_part_one
  moons = [
    Moon.new("Ganymede", [-8, -18, 6]),
    Moon.new("Io", [-11, -14, 4]),
    Moon.new("Europa", [8, -3, -10]),
    Moon.new("Callisto", [-2, -16, 1]),
  ]

  get_final_postions(moons, 1000)
  calculate_total_energy(moons)
end

def get_axis_repeat(axis, moons)
  memo = Set.new()
  count = 0
  while true
    run_gravity_field(moons)
    combination = []
    moons.each { |moon| combination << moon.pos(axis) }
    moons.each { |moon| combination << moon.get_velocity(axis) }
    return count if memo.include?(combination)
    memo.add(combination)
    count += 1
  end
end

def lcm(num1, num2, num3)
  lcm1 = (num1 * num2) / gcd(num1, num2)
  (lcm1 * num3) / gcd(lcm1, num3)
end

def lcm(nums)
  return false if nums.length <= 1
  nums[1..-1].reduce(nums[0]) { |lcm, curr| lcm = (lcm * curr) / gcd(lcm, curr) }
end

def gcd(a, b)
  return a if b == 0
  gcd(b, a % b)
end

def solve_part_two
  moons = [
    Moon.new("Ganymede", [-8, -18, 6]),
    Moon.new("Io", [-11, -14, 4]),
    Moon.new("Europa", [8, -3, -10]),
    Moon.new("Callisto", [-2, -16, 1]),
  ]
  px = get_axis_repeat("x", moons)
  py = get_axis_repeat("y", moons)
  pz = get_axis_repeat("z", moons)
  lcm([px, py, pz])
end

#p solve_part_one()
p solve_part_two()
