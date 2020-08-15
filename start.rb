require_relative 'near_earth_objects'
require_relative 'gui'

application = GUI.new
application.print_intro

date = gets.chomp

asteroids = NearEarthObjects.new.find_neos_by_date(date)
asteroid_list = asteroids[:asteroid_list]

column_labels = { name: "Name", diameter: "Diameter", miss_distance: "Missed The Earth By:" }
column_data = column_labels.each_with_object({}) do |(col, label), hash|
  hash[col] = {
    label: label,
    width: [asteroid_list.map { |asteroid| asteroid.name.length }.max, label.size].max
  }
end

header = "| #{ column_data.map { |_,col| col[:label].ljust(col[:width]) }.join(' | ') } |"
divider = "+-#{column_data.map { |_,col| "-"*col[:width] }.join('-+-') }-+"

def format_row_data(row_data, column_info)
  require "pry"; binding.pry
  row = row_data.keys.map { |key| row_data[key].ljust(column_info[key][:width]) }.join(' | ')
  puts "| #{row} |"
end

def create_rows(asteroid_data, column_info)
  rows = asteroid_data.each { |asteroid| format_row_data(asteroid, column_info) }
end

formatted_date = DateTime.parse(date).strftime("%Y-%m-%d (%A)")
puts "______________________________________________________________________________"
puts "On #{formatted_date}, there were #{asteroids[:total_number_of_asteroids]} objects that almost collided with the earth."
puts "The largest of these was #{asteroids[:biggest_asteroid]} ft. in diameter."
puts "\nHere is a list of objects with details:"
puts divider
puts header
create_rows(asteroid_list, column_data)
puts divider
