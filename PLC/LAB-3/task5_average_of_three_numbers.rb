#!/usr/bin/env ruby

def read_float(prompt)
  loop do
    print prompt
    input = gets&.strip
    exit if input.nil?

    value = Float(input, exception: false)
    return value unless value.nil?

    puts 'Please enter a valid number.'
  end
end

first_number = read_float('Enter the first real number: ')
second_number = read_float('Enter the second real number: ')
third_number = read_float('Enter the third real number: ')

average = (first_number + second_number + third_number) / 3.0

puts format('Average: %.2f', average)
