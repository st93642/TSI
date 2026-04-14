#!/usr/bin/env ruby

PI_VALUE = 3.14159

def read_float(prompt)
  loop do
    print prompt
    input = gets&.strip
    exit if input.nil?

    value = Float(input, exception: false)
    return value if !value.nil? && value >= 0

    puts 'Please enter a valid non-negative number.'
  end
end

radius = read_float('Enter the radius of the circle: ')

area = PI_VALUE * radius * radius
circumference = 2 * PI_VALUE * radius

puts format('Area: %.4f', area)
puts format('Circumference: %.4f', circumference)
