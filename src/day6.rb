=begin 
  While the hints imply a tree, however, you actually end up forming an adjacency list 
  with a hash table approach when building the relation. And it's a good thing too
  since you'll need graph like traversal to solve part II easily.
=end

require 'set'

class OrbitMap
  def initialize(orbit_graph)
    @orbit_graph = orbit_graph
  end

  def self.parse(map_data, birectional = false)
    graph = Hash.new { |h, k| h[k] = Array.new }
    map_data.each do |data_entry|
      key, val = data_entry.split(")")
      graph[key].push(val)
      graph[val].push(key) if birectional
    end
    graph
  end

  def calculate_total_direct_and_indirect_orbits
    total_orbit_dfs(@orbit_graph["COM"], 1)
  end

  def distance_from_santa
    visited = Set.new(["YOU"])
    current_position = @orbit_graph["YOU"].first
    santa_position = @orbit_graph["SAN"].first
    find_santa_dfs(current_position, santa_position, 0, visited)
  end

  private

  def total_orbit_dfs(current_orbits, current_orbit_count)
    return 0 if current_orbits.empty?
    total_orbits = 0
    current_orbits.each do |orbit|
      total_orbits += total_orbit_dfs(@orbit_graph[orbit], current_orbit_count + 1) + current_orbit_count
    end

    total_orbits
  end

  def find_santa_dfs(current_position, target_position, distance, visited)
    return distance if current_position == target_position

    @orbit_graph[current_position].each do |next_position|
      next if visited.include?(next_position)
      visited.add(next_position)
      res = find_santa_dfs(next_position, target_position, distance + 1, visited)
      return res if res
    end
    nil
  end

end
