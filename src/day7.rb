# Phase setting 0 - 4, can only be used once
# Get input signal to view output
# Reuse a modifed DT from day 5

require "byebug"

class Processor
  attr_accessor :index, :memory, :instruction, :inputs
  attr_reader :next_input

  def initialize(memory = [])
    @memory = memory
    @instruction = nil
    @index = 0
    @inputs = []
    @next_input = nil
  end

  def process_instructions
    while self.index < memory.length
      self.instruction = format_instruction(memory[self.index])
      case (instruction[0..1])
      when "10"
        add
      when "20"
        multiply
      when "30"
        read_input
      when "40"
        store_next_input
      when "50"
        jump_if_true
      when "60"
        jump_if_false
      when "70"
        less_than
      when "80"
        equals
      when "99"
        break
      else
        raise "Instruction contains invalid opcode"
      end
    end
    @next_input
  end

  private

  def format_instruction(ins)
    ins = ins.to_s.reverse
    (5 - ins.length).times { ins << "0" }
    ins
  end

  def get_target_address_one
    self.instruction[2] == "0" ? self.memory[self.memory[self.index + 1]] : self.memory[self.index + 1]
  end

  def get_target_address_two
    self.instruction[3] == "0" ? self.memory[self.memory[self.index + 2]] : self.memory[self.index + 2]
  end

  def set_target_memory(val)
    self.memory[self.memory[self.index + 3]] = val
  end

  def add
    val1 = get_target_address_one
    val2 = get_target_address_two
    set_target_memory(val1 + val2)
    self.index += 4
  end

  def multiply
    val1 = get_target_address_one
    val2 = get_target_address_two
    set_target_memory(val1 * val2)
    self.index += 4
  end

  def jump_if_true
    if (get_target_address_one != 0)
      self.index = get_target_address_two
    else
      self.index += 3
    end
  end

  def jump_if_false
    if (get_target_address_one == 0)
      self.index = get_target_address_two
    else
      self.index += 3
    end
  end

  def less_than
    val1 = get_target_address_one
    val2 = get_target_address_two
    if (val1 < val2)
      set_target_memory(1)
    else
      set_target_memory(0)
    end
    self.index += 4
  end

  def equals
    val1 = get_target_address_one
    val2 = get_target_address_two
    if (val1 == val2)
      set_target_memory(1)
    else
      set_target_memory(0)
    end
    self.index += 4
  end

  def read_input
    raise "No input" if self.inputs.empty?
    self.memory[self.memory[self.index + 1]] = @inputs.shift
    self.index += 2
  end

  def store_next_input
    @next_input = get_target_address_one
    self.index += 2
  end
end

INPUT = [3, 8, 1001, 8, 10, 8, 105, 1, 0, 0, 21, 30, 55, 76, 97, 114, 195, 276, 357, 438, 99999, 3, 9, 102, 3, 9, 9, 4, 9, 99, 3, 9, 1002, 9, 3, 9, 1001, 9, 5, 9, 1002, 9, 2, 9, 1001, 9, 2, 9, 102, 2, 9, 9, 4, 9, 99, 3, 9, 1002, 9, 5, 9, 1001, 9, 2, 9, 102, 5, 9, 9, 1001, 9, 4, 9, 4, 9, 99, 3, 9, 1001, 9, 4, 9, 102, 5, 9, 9, 101, 4, 9, 9, 1002, 9, 4, 9, 4, 9, 99, 3, 9, 101, 2, 9, 9, 102, 4, 9, 9, 1001, 9, 5, 9, 4, 9, 99, 3, 9, 1002, 9, 2, 9, 4, 9, 3, 9, 102, 2, 9, 9, 4, 9, 3, 9, 102, 2, 9, 9, 4, 9, 3, 9, 1001, 9, 1, 9, 4, 9, 3, 9, 102, 2, 9, 9, 4, 9, 3, 9, 1002, 9, 2, 9, 4, 9, 3, 9, 102, 2, 9, 9, 4, 9, 3, 9, 102, 2, 9, 9, 4, 9, 3, 9, 1001, 9, 2, 9, 4, 9, 3, 9, 101, 1, 9, 9, 4, 9, 99, 3, 9, 1002, 9, 2, 9, 4, 9, 3, 9, 1001, 9, 2, 9, 4, 9, 3, 9, 101, 1, 9, 9, 4, 9, 3, 9, 1002, 9, 2, 9, 4, 9, 3, 9, 1001, 9, 2, 9, 4, 9, 3, 9, 1001, 9, 2, 9, 4, 9, 3, 9, 1002, 9, 2, 9, 4, 9, 3, 9, 1001, 9, 2, 9, 4, 9, 3, 9, 101, 2, 9, 9, 4, 9, 3, 9, 102, 2, 9, 9, 4, 9, 99, 3, 9, 101, 1, 9, 9, 4, 9, 3, 9, 1002, 9, 2, 9, 4, 9, 3, 9, 1001, 9, 1, 9, 4, 9, 3, 9, 1002, 9, 2, 9, 4, 9, 3, 9, 1001, 9, 1, 9, 4, 9, 3, 9, 1001, 9, 1, 9, 4, 9, 3, 9, 101, 1, 9, 9, 4, 9, 3, 9, 102, 2, 9, 9, 4, 9, 3, 9, 1001, 9, 1, 9, 4, 9, 3, 9, 1001, 9, 1, 9, 4, 9, 99, 3, 9, 1001, 9, 1, 9, 4, 9, 3, 9, 1002, 9, 2, 9, 4, 9, 3, 9, 1001, 9, 2, 9, 4, 9, 3, 9, 1002, 9, 2, 9, 4, 9, 3, 9, 1001, 9, 1, 9, 4, 9, 3, 9, 101, 2, 9, 9, 4, 9, 3, 9, 102, 2, 9, 9, 4, 9, 3, 9, 101, 2, 9, 9, 4, 9, 3, 9, 101, 1, 9, 9, 4, 9, 3, 9, 1001, 9, 1, 9, 4, 9, 99, 3, 9, 101, 2, 9, 9, 4, 9, 3, 9, 102, 2, 9, 9, 4, 9, 3, 9, 101, 2, 9, 9, 4, 9, 3, 9, 101, 1, 9, 9, 4, 9, 3, 9, 101, 2, 9, 9, 4, 9, 3, 9, 1002, 9, 2, 9, 4, 9, 3, 9, 102, 2, 9, 9, 4, 9, 3, 9, 1001, 9, 1, 9, 4, 9, 3, 9, 1001, 9, 1, 9, 4, 9, 3, 9, 101, 2, 9, 9, 4, 9, 99]

class Amplifier
  attr_accessor :processor, :inputs, :feed_back

  def initialize(processor, phase = nil, input = nil)
    @processor = processor
    @inputs = []
    @inputs << phase if phase
    @inputs << input if input
    @feed_back = true
  end

  def calculate_output
    self.processor.inputs = self.inputs
    begin
      self.processor.process_instructions
      self.feed_back = false
    rescue
      self.inputs = []
      self.feed_back = true
    ensure
      return self.processor.next_input
    end
  end
end

def calculate_max_thrust(data)
  max_thrust = 0
  phase_setting = [0, 1, 2, 3, 4]
  phase_setting.permutation.each do |setting|
    a1 = Amplifier.new(Processor.new(data), setting[0])
    a2 = Amplifier.new(Processor.new(data), setting[1], a1.calculate_output)
    a3 = Amplifier.new(Processor.new(data), setting[2], a2.calculate_output)
    a4 = Amplifier.new(Processor.new(data), setting[3], a3.calculate_output)
    a5 = Amplifier.new(Processor.new(data), setting[4], a4.calculate_output)
    current_thrust = a5.calculate_output
    max_thrust = current_thrust > max_thrust ? current_thrust : max_thrust
  end
  max_thrust
end

# p calculate_max_thrust(INPUT)

def calculate_max_thrust_with_feedback(data)
  max_thrust = 0
  phase_setting = [5, 6, 7, 8, 9]
  phase_setting.permutation.each do |setting|
    queue = [0]
    a1 = Amplifier.new(Processor.new(data.dup), setting[0])
    a2 = Amplifier.new(Processor.new(data.dup), setting[1])
    a3 = Amplifier.new(Processor.new(data.dup), setting[2])
    a4 = Amplifier.new(Processor.new(data.dup), setting[3])
    a5 = Amplifier.new(Processor.new(data.dup), setting[4])

    i = 0
    system = [a1, a2, a3, a4, a5]
    until system.all? { |amp| amp.feed_back == false }
      amp = system[i]
      amp.inputs << queue.shift if amp.feed_back
      queue << amp.calculate_output
      i += 1
      i = 0 if i == system.length
    end
    max_thrust = queue[0] > max_thrust ? queue[0] : max_thrust
  end
  max_thrust
end


p calculate_max_thrust_with_feedback(INPUT)


