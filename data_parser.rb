#!/usr/bin/env ruby
#----------------------------------------------
#Explorer Mode
#
#Good news Rubyists!
#We have a week of records tracking what we shipped at Planet Express. I need you to answer a few questions for Hermes.
#
# 1) How much money did we make this week?
# 2) How much of a bonus did each employee get? (bonuses are paid to employees who pilot the Planet Express)
# 3) How many trips did each employee pilot?
# 4) Define and use y"our Delivery class to represent each shipment
#
# Different e"mployees have favorite destinations they always pilot to
#
# Fry - pilots to Earth (because he isn't allowed into space)
# Amy - pilots to Mars (so she can visit her family)
# Bender - pilots to Uranus (teeheee...)
# Leela - pilots everywhere else because she is the only responsible one
# They get a bonus of 10% of the money for the shipment as the bonus
#----------------------------------------------
file_argument = ARGV[0].to_s
puts "Argument: #{file_argument}"
require 'csv'


#creates this thing that is like a hash...
# results of looping through the csv_string variable and doing a puts x and a puts x.inspect
#                   Earth,Hamburgers,150,30000
#<CSV::Row destination:"Earth" what_got_shipped:"Hamburgers" number_of_crates:"150" money_we_made:"30000">
#                   Moon,Tacos,33,44500
#<CSV::Row destination:"Moon" what_got_shipped:"Tacos" number_of_crates:"33" money_we_made:"44500">
#                   Earth,Movies,34,5000
#<CSV::Row destination:"Earth" what_got_shipped:"Movies" number_of_crates:"34" money_we_made:"5000">
#                   Mars,BBQ Sauce,999,15000
#<CSV::Row destination:"Mars" what_got_shipped:"BBQ Sauce" number_of_crates:"999" money_we_made:"15000">
#                   Uranus,Whiskey,1000,345600
#<CSV::Row destination:"Uranus" what_got_shipped:"Whiskey" number_of_crates:"1000" money_we_made:"345600">
#                   Jupiter,Books,10,3451
#<CSV::Row destination:"Jupiter" what_got_shipped:"Books" number_of_crates:"10" money_we_made:"3451">
#                   Pluto,Beer,100,2344
#<CSV::Row destination:"Pluto" what_got_shipped:"Beer" number_of_crates:"100" money_we_made:"2344">
#                   Uranus,Pizza,66,10000
#<CSV::Row destination:"Uranus" what_got_shipped:"Pizza" number_of_crates:"66" money_we_made:"10000">
#                   Saturn,Pizza,26,1000
#<CSV::Row destination:"Saturn" what_got_shipped:"Pizza" number_of_crates:"26" money_we_made:"1000">
#                   Mercury,Pizza,36,80000
#<CSV::Row destination:"Mercury" what_got_shipped:"Pizza" number_of_crates:"36" money_we_made:"80000">



class Delivery
  attr_accessor :destination, :what_got_shipped, :number_of_crates, :money_we_made

  def initialize(destination:, what_got_shipped:, number_of_crates:, money_we_made:)
    @destination = destination
    @what_got_shipped = what_got_shipped
    @number_of_crates = number_of_crates.to_i
    @money_we_made = money_we_made.to_i
  end
end

#csv_string = CSV.foreach("planet_express_logs.csv", headers: true, header_converters: :symbol)


#----------------------------------
# class Parse
# Notes:  for a class, only things in the class or accessible.
# I was getting stuck on making a deliveries[] in my main stream of code
# This wasn't available to the class.  To a method outside of the class
# would have been?

class Parse

  attr_accessor :file_name
  def initialize(file_name:)
    @file_name = file_name
  end

  def parse_data
     csv_string = CSV.foreach(file_name, headers: true, header_converters: :symbol)
     array_from_file = []
#Chris said this each could be a collect....
     csv_string.each do |x|
       array_from_file << Delivery.new(x)
     end
     array_from_file
  end

end


deliveries = Parse.new(file_name: file_argument).parse_data
#csv_string = Parse.new(file_name: "planet_express_logs.csv").parse_data


#csv_string.each do |x|
#  deliveries << Delivery.new(x)
#end

# 1)  How much money did we make?  use reduce command

total_made = deliveries.reduce(0) { |sum, row|  sum += row.money_we_made  }
puts "Total money made for all deliveries: #{total_made}"
puts " "

#2) How much of a bonus did each employee get? (bonuses are paid to employees who pilot the Planet Express)

bonus = { "Fry" => 0,
          "Bender" => 0,
          "Amy" => 0,
          "Leela" => 0
          }
plant_to_pilot = {
          "Earth" => "Fry",
          "Uranus" => "Bender",
          "Mars" => 'Amy',
          }
plant_to_pilot.default = "Leela"

deliveries.each do |b|
  #puts b.inspect
  person = plant_to_pilot[b.destination]
  amount = b.money_we_made * 10 / 100
  bonus[person] += amount
end


bonus.each_pair { |key, value| puts "Pilot #{key} made a bonus of #{value}"}
puts " "


#Array#count{|i| i.even?}

# 3) How many trips did each employee pilot?

flight_count = { "Fry" => 0,
          "Bender" => 0,
          "Amy" => 0,
          "Leela" => 0
          }

deliveries.each do |b|
  person = plant_to_pilot[b.destination]
  flight_count[person] += 1
end

flight_count.each_pair { |key, value| puts "Pilot #{key} made #{value} flights"}
puts " "

#Adventure Mode
#How much money did we make broken down by planet?


unique_keys = deliveries.collect { |x| x.destination }
unique_keys.uniq!

unique_keys.each do |x|
  dest_var = x
  deliveries_by_key = deliveries.select {|z| z.destination == dest_var}
  total_made = 0
  total_made = deliveries_by_key.reduce(0) { |sum, row|  sum += row.money_we_made  }

#total_made = deliveries.reduce(0) { |sum, row|  sum += row.money_we_made  }
  puts "Destination #{dest_var} and money made #{total_made}"

end
