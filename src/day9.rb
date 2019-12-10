class Processor
  attr_accessor :index, :memory, :instruction, :inputs, :relative_base
  attr_reader :output

  def initialize(memory = [], relative_base = 0)
    @memory = memory
    @relative_base = relative_base
    @inputs = []
    @output = []
    @errors = []
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
        read_input
      when "40"
        set_output
      when "50"
        jump_if_true
      when "60"
        jump_if_false
      when "70"
        less_than
      when "80"
        equals
      when "90"
        adjust_relative_base
      when "99"
        break
      else
        raise "Instruction contains invalid opcode"
      end
    end
    self.output
  end

  private

  def format_instruction(ins)
    ins = ins.to_s.reverse
    (5 - ins.length).times { ins << "0" }
    ins
  end

  def get_target_address(offset)
    target_index = self.index + offset 
    target_val = self.memory[target_index]
    case self.instruction[offset + 1]
    when "0"
      return self.memory[target_val] || 0 if target_val >= 0
      raise 'Cannot access negative memory address'
    when "1"
      return target_val
    when "2"
      return self.memory[self.relative_base + target_val]
    else
      raise "Bad params error"
    end
  end

  def set_target_address( offset, val )
    target_index = self.index + offset
    case self.instruction[offset + 1]
    when "0"
      self.memory[self.memory[target_index]] = val
    when "1"
      self.memory[self.memory[target_index]] = val
    when "2"
      self.memory[self.relative_base + self.memory[target_index]] = val
    else
      raise "Invalid mode for write"
    end
  end


  def add
    val1 = get_target_address(1)
    val2 = get_target_address(2)
    set_target_address(3, val1 + val2)
    self.index += 4
  end

  def multiply
    val1 = get_target_address(1)
    val2 = get_target_address(2)
    set_target_address(3, val1 * val2)
    self.index += 4
  end

  def jump_if_true
    if (get_target_address(1) != 0)
      self.index = get_target_address(2)
    else
      self.index += 3
    end
  end

  def jump_if_false
    if (get_target_address(1) == 0)
      self.index = get_target_address(2)
    else
      self.index += 3
    end
  end

  def less_than
    val1 = get_target_address(1)
    val2 = get_target_address(2)
    if (val1 < val2)
      set_target_address(3, 1)
    else
      set_target_address(3, 0)
    end
    self.index += 4
  end

  def equals
    val1 = get_target_address(1)
    val2 = get_target_address(2)
    if (val1 == val2)
      set_target_address(3, 1)
    else
      set_target_address(3, 0)
    end
    self.index += 4
  end

  def read_input
    raise "No input" if self.inputs.empty?
    set_target_address(1, @inputs.shift)
    self.index += 2
  end

  def set_output
    @output << get_target_address(1)
    self.index += 2
  end

  def adjust_relative_base
    self.relative_base += get_target_address(1)
    self.index += 2
  end
end

test1 = [109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99]
test2 = [1102,34915192,34915192,7,4,7,99,0]
test3 = [104,1125899906842624,99]
test4 = [109, -1, 4, 1, 99]
test5 = [109, -1, 104, 1, 99]
test6 = [109, -1, 204, 1, 99]
test7 = [109, 1, 9, 2, 204, -6, 99]
test8 = [109, 1, 109, 9, 204, -6, 99]
test9 = [109, 1, 209, -1, 204, -106, 99]
test10 = [109, 1, 3, 3, 204, 2, 99]
test11 = [109, 1, 203, 2, 204, 2, 99]


# [test1, test2, test3, test4, test5, test6, test7, test8, test9, test10, test11].each do |test|
#   p1 = Processor.new(test)
#   p1.inputs = [1]
#   p1.process_instructions
#   p p1.output
# end

p1 = Processor.new(memory)
p1.inputs << 2
p1.process_instructions
p p1.output
