#!/usr/bin/env ruby

def read_float(prompt)
  loop do
    print prompt
    input = gets&.strip
    exit if input.nil?

    value = Float(input, exception: false)
    return value if !value.nil? && value >= 0

    puts 'Please enter a valid non-negative speed.'
  end
end

speed_kmph = read_float('Enter the speed in km/h: ')
speed_mph = speed_kmph * 0.62137

puts format('%.2f km/h = %.2f mph', speed_kmph, speed_mph)
