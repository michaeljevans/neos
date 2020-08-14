require 'faraday'
require 'figaro'
require 'json'
require 'pry'
# Load ENV vars via Figaro
Figaro.application = Figaro::Application.new(environment: 'production', path: File.expand_path('../config/application.yml', __FILE__))
Figaro.load

class NearEarthObjects
  def self.find_neos_by_date(date)
    conn = Faraday.new(
      url: 'https://api.nasa.gov',
      params: { start_date: date, api_key: ENV['nasa_api_key']}
    )
    raw_asteroids_data = conn.get('/neo/rest/v1/feed')

    parsed_asteroids_data = JSON.parse(raw_asteroids_data.body, symbolize_names: true)[:near_earth_objects][:"#{date}"]

    largest_asteroid_diameter = parsed_asteroids_data.map do |asteroid|
      asteroid[:estimated_diameter][:feet][:estimated_diameter_max].to_i
    end.max { |a,b| a <=> b}

    total_number_of_asteroids = parsed_asteroids_data.count

    asteroids = parsed_asteroids_data.map do |asteroid_data|
      Asteroid.new(asteroid_data)
    end

    {
      asteroid_list: asteroids,
      biggest_asteroid: largest_asteroid_diameter,
      total_number_of_asteroids: total_number_of_asteroids
    }
  end
end

class Asteroid
  attr_reader :name, :diameter, :miss_distance
  def initialize(asteroid_data)
    @name          = asteroid_data[:name]
    @diameter      = "#{asteroid_data[:estimated_diameter][:feet][:estimated_diameter_max].to_i} ft"
    @miss_distance = "#{asteroid_data[:close_approach_data][0][:miss_distance][:miles].to_i} miles"
  end
end
