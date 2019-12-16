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
    @is_done = false
  end

  def process_instructions
    return if @is_done 
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
    @is_done = true
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
    if @interactive
      p get_target_address(1)
    else
      @output << get_target_address(1)
    end
    self.index += 2
  end

  def adjust_relative_base
    self.relative_base += get_target_address(1)
    self.index += 2
  end
end
