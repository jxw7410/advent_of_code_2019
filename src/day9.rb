class Processor
  attr_accessor :index, :memory, :instruction, :inputs, :relative_base
  attr_reader :output

  def initialize(memory = [], relative_base = 0, interactive = true)
    @memory = memory
    @relative_base = relative_base
    @inputs = []
    @output = []
    @errors = []
    @interactive = interactive
    @instruction = nil
    @index = 0
  end

  def process_instructions
    while self.index < memory.length
      self.instruction = format_instruction(memory[self.index])
      case (instruction[0..1])
      when "10"
        alu "ADD"
      when "20"
        alu "MUL"
      when "30"
        read_input
      when "40"
        set_output
      when "50"
        jump { |a, b| a != b }
      when "60"
        jump { |a, b| a == b }
      when "70"
        equality { |a, b| a < b }
      when "80"
        equality { |a, b| a == b }
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
      raise "Cannot access negative memory address"
    when "1"
      return target_val
    when "2"
      return self.memory[self.relative_base + target_val]
    else
      raise "Invalid mode for read."
    end
  end

  def set_target_address(offset, val)
    target_index = self.index + offset
    case self.instruction[offset + 1]
    when "0"
      self.memory[self.memory[target_index]] = val
    when "1"
      self.memory[self.memory[target_index]] = val
    when "2"
      self.memory[self.relative_base + self.memory[target_index]] = val
    else
      raise "Invalid mode for write."
    end
  end

  # arithmetic logic unit
  def alu(type)
    val1 = get_target_address(1)
    val2 = get_target_address(2)
    case type
    when "ADD"
      set_target_address(3, val1 + val2)
    when "MUL"
      set_target_address(3, val1 * val2)
    else
      raise "Invalid arithmetic opcode"
    end
    self.index += 4
  end

  def jump(&proc)
    if proc.call(get_target_address(1), 0)
      self.index = get_target_address(2)
    else
      self.index += 3
    end
  end

  def equality(&proc)
    val1 = get_target_address(1)
    val2 = get_target_address(2)
    if proc.call(val1, val2)
      set_target_address(3, 1)
    else
      set_target_address(3, 0)
    end
    self.index += 4
  end

  def read_input
    if @interactive
      print "Please enter a mode: "
      val = gets.chomp.to_i
    else
      raise "No input" if self.inputs.empty?
      val = @inputs.shift
    end

    set_target_address(1, val)
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

test1 = [109, 1, 204, -1, 1001, 100, 1, 100, 1008, 100, 16, 101, 1006, 101, 0, 99]
test2 = [1102, 34915192, 34915192, 7, 4, 7, 99, 0]
test3 = [104, 1125899906842624, 99]
test4 = [109, -1, 4, 1, 99]
test5 = [109, -1, 104, 1, 99]
test6 = [109, -1, 204, 1, 99]
test7 = [109, 1, 9, 2, 204, -6, 99]
test8 = [109, 1, 109, 9, 204, -6, 99]
test9 = [109, 1, 209, -1, 204, -106, 99]
test10 = [109, 1, 3, 3, 204, 2, 99]
test11 = [109, 1, 203, 2, 204, 2, 99]

# [test1, test2, test3, test4, test5, test6, test7, test8, test9, test10, test11].each do |test|
#   p1 = Processor.new(test, 0, false)
#   p1.inputs = [1]
#   p1.process_instructions
#   p p1.output
# end

# memory = [1102, 34463338, 34463338, 63, 1007, 63, 34463338, 63, 1005, 63, 53, 1102, 1, 3, 1000, 109, 988, 209, 12, 9, 1000, 209, 6, 209, 3, 203, 0, 1008, 1000, 1, 63, 1005, 63, 65, 1008, 1000, 2, 63, 1005, 63, 904, 1008, 1000, 0, 63, 1005, 63, 58, 4, 25, 104, 0, 99, 4, 0, 104, 0, 99, 4, 17, 104, 0, 99, 0, 0, 1101, 0, 0, 1020, 1102, 1, 800, 1023, 1101, 0, 388, 1025, 1101, 0, 31, 1012, 1102, 1, 1, 1021, 1101, 22, 0, 1014, 1101, 0, 30, 1002, 1101, 0, 716, 1027, 1102, 32, 1, 1009, 1101, 0, 38, 1017, 1102, 20, 1, 1015, 1101, 33, 0, 1016, 1101, 0, 35, 1007, 1101, 0, 25, 1005, 1102, 28, 1, 1011, 1102, 1, 36, 1008, 1101, 0, 39, 1001, 1102, 1, 21, 1006, 1101, 397, 0, 1024, 1102, 1, 807, 1022, 1101, 0, 348, 1029, 1101, 0, 23, 1003, 1101, 29, 0, 1004, 1102, 1, 26, 1013, 1102, 34, 1, 1018, 1102, 1, 37, 1010, 1101, 0, 27, 1019, 1102, 24, 1, 1000, 1101, 353, 0, 1028, 1101, 0, 723, 1026, 109, 14, 2101, 0, -9, 63, 1008, 63, 27, 63, 1005, 63, 205, 1001, 64, 1, 64, 1106, 0, 207, 4, 187, 1002, 64, 2, 64, 109, -17, 2108, 24, 6, 63, 1005, 63, 223, 1105, 1, 229, 4, 213, 1001, 64, 1, 64, 1002, 64, 2, 64, 109, 7, 2101, 0, 2, 63, 1008, 63, 21, 63, 1005, 63, 255, 4, 235, 1001, 64, 1, 64, 1106, 0, 255, 1002, 64, 2, 64, 109, -7, 2108, 29, 7, 63, 1005, 63, 273, 4, 261, 1106, 0, 277, 1001, 64, 1, 64, 1002, 64, 2, 64, 109, 10, 1208, -5, 31, 63, 1005, 63, 293, 1105, 1, 299, 4, 283, 1001, 64, 1, 64, 1002, 64, 2, 64, 109, 2, 1207, -1, 35, 63, 1005, 63, 315, 1106, 0, 321, 4, 305, 1001, 64, 1, 64, 1002, 64, 2, 64, 109, 8, 1205, 3, 333, 1106, 0, 339, 4, 327, 1001, 64, 1, 64, 1002, 64, 2, 64, 109, 11, 2106, 0, 0, 4, 345, 1106, 0, 357, 1001, 64, 1, 64, 1002, 64, 2, 64, 109, -15, 21108, 40, 40, 6, 1005, 1019, 379, 4, 363, 1001, 64, 1, 64, 1106, 0, 379, 1002, 64, 2, 64, 109, 16, 2105, 1, -5, 4, 385, 1001, 64, 1, 64, 1105, 1, 397, 1002, 64, 2, 64, 109, -25, 2102, 1, -1, 63, 1008, 63, 26, 63, 1005, 63, 421, 1001, 64, 1, 64, 1106, 0, 423, 4, 403, 1002, 64, 2, 64, 109, -8, 1202, 9, 1, 63, 1008, 63, 25, 63, 1005, 63, 445, 4, 429, 1105, 1, 449, 1001, 64, 1, 64, 1002, 64, 2, 64, 109, 5, 1207, 0, 40, 63, 1005, 63, 467, 4, 455, 1106, 0, 471, 1001, 64, 1, 64, 1002, 64, 2, 64, 109, -6, 2107, 24, 8, 63, 1005, 63, 487, 1105, 1, 493, 4, 477, 1001, 64, 1, 64, 1002, 64, 2, 64, 109, 15, 21107, 41, 40, 1, 1005, 1011, 509, 1106, 0, 515, 4, 499, 1001, 64, 1, 64, 1002, 64, 2, 64, 109, 12, 1205, -1, 529, 4, 521, 1105, 1, 533, 1001, 64, 1, 64, 1002, 64, 2, 64, 109, -20, 2102, 1, 2, 63, 1008, 63, 29, 63, 1005, 63, 555, 4, 539, 1105, 1, 559, 1001, 64, 1, 64, 1002, 64, 2, 64, 109, 15, 1201, -9, 0, 63, 1008, 63, 38, 63, 1005, 63, 579, 1105, 1, 585, 4, 565, 1001, 64, 1, 64, 1002, 64, 2, 64, 109, -2, 21102, 42, 1, -3, 1008, 1012, 44, 63, 1005, 63, 609, 1001, 64, 1, 64, 1106, 0, 611, 4, 591, 1002, 64, 2, 64, 109, -21, 2107, 29, 8, 63, 1005, 63, 629, 4, 617, 1106, 0, 633, 1001, 64, 1, 64, 1002, 64, 2, 64, 109, 15, 1202, 0, 1, 63, 1008, 63, 30, 63, 1005, 63, 657, 1001, 64, 1, 64, 1106, 0, 659, 4, 639, 1002, 64, 2, 64, 109, 15, 21102, 43, 1, -8, 1008, 1016, 43, 63, 1005, 63, 681, 4, 665, 1105, 1, 685, 1001, 64, 1, 64, 1002, 64, 2, 64, 109, -10, 21107, 44, 45, -4, 1005, 1010, 707, 4, 691, 1001, 64, 1, 64, 1106, 0, 707, 1002, 64, 2, 64, 109, 11, 2106, 0, 2, 1001, 64, 1, 64, 1106, 0, 725, 4, 713, 1002, 64, 2, 64, 109, -16, 21101, 45, 0, 8, 1008, 1017, 43, 63, 1005, 63, 749, 1001, 64, 1, 64, 1105, 1, 751, 4, 731, 1002, 64, 2, 64, 109, -3, 1208, 2, 36, 63, 1005, 63, 773, 4, 757, 1001, 64, 1, 64, 1106, 0, 773, 1002, 64, 2, 64, 109, 18, 1206, -4, 787, 4, 779, 1105, 1, 791, 1001, 64, 1, 64, 1002, 64, 2, 64, 109, -8, 2105, 1, 7, 1001, 64, 1, 64, 1106, 0, 809, 4, 797, 1002, 64, 2, 64, 109, -2, 21108, 46, 44, 2, 1005, 1016, 825, 1105, 1, 831, 4, 815, 1001, 64, 1, 64, 1002, 64, 2, 64, 109, 7, 21101, 47, 0, -8, 1008, 1013, 47, 63, 1005, 63, 857, 4, 837, 1001, 64, 1, 64, 1105, 1, 857, 1002, 64, 2, 64, 109, -17, 1201, -4, 0, 63, 1008, 63, 24, 63, 1005, 63, 883, 4, 863, 1001, 64, 1, 64, 1105, 1, 883, 1002, 64, 2, 64, 109, 10, 1206, 7, 895, 1106, 0, 901, 4, 889, 1001, 64, 1, 64, 4, 64, 99, 21102, 1, 27, 1, 21102, 1, 915, 0, 1105, 1, 922, 21201, 1, 24405, 1, 204, 1, 99, 109, 3, 1207, -2, 3, 63, 1005, 63, 964, 21201, -2, -1, 1, 21101, 942, 0, 0, 1106, 0, 922, 22102, 1, 1, -1, 21201, -2, -3, 1, 21101, 0, 957, 0, 1106, 0, 922, 22201, 1, -1, -2, 1106, 0, 968, 21201, -2, 0, -2, 109, -3, 2106, 0, 0]
# p1 = Processor.new(memory)
# p1.process_instructions
# p p1.output
