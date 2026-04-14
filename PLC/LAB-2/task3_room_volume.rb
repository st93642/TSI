#!/usr/bin/env ruby

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

width = read_float('Enter the room width in metres: ')
length = read_float('Enter the room length in metres: ')
height = read_float('Enter the room height in metres: ')

volume_cubic_metres = width * length * height
volume_cubic_centimetres = volume_cubic_metres * 1_000_000

puts format('Volume: %.3f cubic metres', volume_cubic_metres)
puts format('Volume: %.0f cubic centimetres', volume_cubic_centimetres)
