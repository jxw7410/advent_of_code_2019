def decrypt_opcode(opcode)
  i = 0

  while i < opcode.length
    current_val = opcode[i]
    if current_val == 1 || current_val == 2
      target_index = opcode[i + 3]
      val1 = opcode[opcode[i + 1]]
      val2 = opcode[opcode[i + 2]]
      opcode[target_index] = current_val == 1 ? val1 + val2 : val1 * val2 if opcode[target_index]
    elsif current_val == 99
      break
    else
      raise "Invalid opcode"
    end
    i += 4
  end
  opcode[0]
end

def findIntcode(data, target)
  noun = 0
  while noun < data.length 
    verb = 0
    while verb < data.length 
      copy_data = data.map{|val| val}
      copy_data[1] = noun 
      copy_data[2] = verb 
      return 100 * noun + verb if decrypt_opcode(copy_data) == target
      verb += 1
    end
    noun += 1
  end
  
end

