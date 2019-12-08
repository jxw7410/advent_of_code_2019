class DiagonsticTest
  attr_accessor :index, :memory, :instruction

  def initialize(memory)
    @memory = memory
    @instruction = nil
    @index = 0
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
        get_input
      when "40"
        print_diagnostic_code
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
  end

  private

  def format_instruction(instruction)
    instruction = instruction.to_s.reverse
    (5 - instruction.length).times { instruction << "0" }
    instruction
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

  def get_input
    p "Please enter a numeric id:"
    self.memory[self.memory[self.index + 1]] = gets.chomp.to_i
    self.index += 2
  end

  def print_diagnostic_code
    p get_target_address_one
    self.index += 2
  end
end

INPUT = [
  3, 26, 1001, 26, -4, 26, 3, 27, 1002, 27, 2, 27, 1, 27, 26,
  27, 4, 27, 1001, 28, -1, 28, 1005, 28, 6, 99, 0, 0, 5,
]

dt = DiagonsticTest.new(INPUT)
dt.process_instructions