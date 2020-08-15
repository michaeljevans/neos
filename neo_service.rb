require 'faraday'
require 'json'

class NEOService

  def get_neo_data(date)
    response = establish_connection(date).get('/neo/rest/v1/feed')
    JSON.parse(response.body, symbolize_names: true)[:near_earth_objects][:"#{date}"]
  end

  def establish_connection(date)
    Faraday.new(
      url: 'https://api.nasa.gov',
      params: { start_date: date, api_key: ENV['nasa_api_key'] }
    )
  end

end
