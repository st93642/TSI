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

length = read_float('Enter the rectangle length: ')
breadth = read_float('Enter the rectangle breadth: ')

area = length * breadth
perimeter = 2 * (length + breadth)

puts format('Area: %.2f', area)
puts format('Perimeter: %.2f', perimeter)
