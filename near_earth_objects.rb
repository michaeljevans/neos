require 'figaro'
require_relative 'neo_service'
require_relative 'asteroid'

Figaro.application = Figaro::Application.new(environment: 'production', path: File.expand_path('../config/application.yml', __FILE__))
Figaro.load

class NearEarthObjects

  def find_neos_by_date(date)
    service = NEOService.new
    neo_data = service.get_neo_data(date)

    {
      asteroid_list: asteroids(neo_data),
      biggest_asteroid: largest_asteroid_diameter(neo_data),
      total_number_of_asteroids: asteroid_count(neo_data)
    }
  end

  def asteroids(neo_data)
    neo_data.map { |asteroid_data| Asteroid.new(asteroid_data) }
  end

  def largest_asteroid_diameter(neo_data)
    neo_data.map { |asteroid| asteroid[:estimated_diameter][:feet][:estimated_diameter_max].to_i }.max
  end

  def asteroid_count(neo_data)
    neo_data.count
  end

end
