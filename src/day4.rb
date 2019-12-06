# day 4

# 6 digitslong
# within the limits
# two adjacent numbers are the same
# from left to right digits are either the same or always increasing
# part 1 brute force approach
def find_possible_password(lower_limit, upper_limit)
  current_number = lower_limit
  count = 0
  until current_number > upper_limit
    count += 1 if is_successive?(current_number) && has_adjacent_values?(current_number)
    current_number += 1
  end

  return count
end

def is_successive?(number)
  num_arr = []
  until number == 0
    num_arr.push(number % 10)
    number /= 10
  end
  is_reverse_sorted?(num_arr)
end

def has_adjacent_values?(number)
  prev_num = number % 10
  number /= 10
  until number == 0
    current_num = number % 10
    number /= 10
    return true if current_num == prev_num
    prev_num = current_num
  end
  false
end

def is_reverse_sorted?(arr)
  (arr.length - 1).downto(1) do |index|
    return false if arr[index] > arr[index - 1]
  end
  true
end

#p find_possible_password(273025, 767253)

# part II

def find_possible_password_part_2(lower_limit, upper_limit)
  current_number = lower_limit
  count = 0
  until current_number > upper_limit
    if is_successive?(current_number) && has_adjacent_values?(current_number)
      count += 1 if has_double_adjacent_value?(current_number)
    end
    current_number += 1
  end

  return count
end

def has_double_adjacent_value?(number)
  freq_counter = Hash.new(0)
  until number == 0
    freq_counter[number % 10] += 1
    number /= 10
  end
  freq_counter.values.each {|count| return true if count == 2}
  false 
end


p find_possible_password_part_2(273025, 767253)