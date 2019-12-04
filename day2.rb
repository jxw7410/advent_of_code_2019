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

TESTDATA1 = [1, 9, 10, 3, 2, 3, 11, 0, 99, 30, 40, 50]
TESTDATA2 = [1, 0, 0, 0, 99]
TESTDATA3 = [2, 3, 0, 3, 99]
TESTDATA4 = [2, 4, 4, 5, 99, 0]
TESTDATA5 = [1, 1, 1, 4, 99, 5, 6, 0, 99]
DATA = [1,12,2,3,1,1,2,3,1,3,4,3,1,5,0,3,2,10,1,19,1,19,9,23,1,23,13,27,1,10,27,31,2,31,13,35,1,10,35,39,2,9,39,43,2,43,9,47,1,6,47,51,1,10,51,55,2,55,13,59,1,59,10,63,2,63,13,67,2,67,9,71,1,6,71,75,2,75,9,79,1,79,5,83,2,83,13,87,1,9,87,91,1,13,91,95,1,2,95,99,1,99,6,0,99,2,14,0,0]


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


p findIntcode(DATA, 19690720)