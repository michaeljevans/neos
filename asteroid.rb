class Asteroid
  attr_reader :name, :diameter, :miss_distance

  def initialize(asteroid_data)
    @name          = asteroid_data[:name]
    @diameter      = "#{asteroid_data[:estimated_diameter][:feet][:estimated_diameter_max].to_i} ft"
    @miss_distance = "#{asteroid_data[:close_approach_data][0][:miss_distance][:miles].to_i} miles"
  end

end
