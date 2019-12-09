=begin
  Day 8 of advent of code
  - Some ideas: 
  - partition input string by 25 vals each, and form groups of 6 with the parititions
  - need to account for number of 1 digits, and number of 2 digits
  - Can be checked by a function that divides by 10, and then 100.

=end

class ImageDecoder
  attr_reader :data
  attr_accessor :width, :height

  def initialize(data, width = 1, height = 1)
    @data = data
    @width = width
    @height = height
  end

  def partition_data
    partitions = []
    p_index = 0
    until p_index == self.data.length
      partition = []
      until partition.length == width || !self.data[p_index]
        partition << self.data[p_index]
        p_index += 1
      end
      partitions << partition if partition.length == self.width
    end
    partitions
  end

  def group_partitions
    groups = []
    partitions = self.partition_data
    p_index = 0
    until p_index == partitions.length 
      group = []
      until group.length == self.height || !partitions[p_index]
        group << partitions[p_index]
        p_index += 1
      end
      groups << group
    end
    groups
  end


  def find_layer_with_least_zeros 
    layer = 1
    prev_zero_count = 1.0/0.0
    self.group_partitions.each_with_index do |group, index|
      zero_count = 0
      group.each do |partition|
        partition.each {|num| zero_count += 1 if num == 0}
      end
      if zero_count < prev_zero_count
        layer = index + 1
        prev_zero_count = zero_count
      end 
    end
    layer
  end


end

def format_input_data(input)
  input.split("").map { |val| val.to_i }
end






def solve_first_puzzle(image_decoder)
  layer = image_decoder.find_layer_with_least_zeros
  freq_hash = { 1 => 0, 2 => 0}
  group = image_decoder.group_partitions[layer-1]
  group.each do |partition|
    partition.each { |num| freq_hash[num] += 1 if num == 1 || num == 2}
  end

  freq_hash[1] * freq_hash[2]
end

def solve_second_puzzle(image_decoder)
  # initialize an mxn matrix to represent final image
  final_image = Array.new(image_decoder.height){ Array.new(image_decoder.width, nil)}
  groups = image_decoder.group_partitions

  for row in 0...image_decoder.height 
    for col in 0...image_decoder.width 
      final_image[row][col] = find_top_pixel(groups, row, col)    
    end
  end

  final_image
end


def find_top_pixel(groups, row, col)
  groups.each do |layer|
    pixel_color = layer[row][col]
    return 1 if pixel_color == 1
    return 0 if pixel_color == 0
    #return pixel_color if pixel_color != 2
  end
  2
end

raw_input = "get this from advent code's website"

id = ImageDecoder.new(format_input_data(raw_input), 25, 6);

p solve_first_puzzle(id)

# contenxt - each layer are images, and imagine stacking them from top to bottom...whatever color comes first, stays first

solve_second_puzzle(id).each do |partition|
 p partition
end