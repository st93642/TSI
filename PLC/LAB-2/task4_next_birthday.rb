#!/usr/bin/env ruby

def read_integer(prompt)
  loop do
    print prompt
    input = gets&.strip
    exit if input.nil?

    value = Integer(input, exception: false)
    return value if !value.nil? && value >= 0

    puts 'Please enter a valid age in whole years.'
  end
end

age = read_integer('Enter your age in years: ')

puts "On your next birthday you will be #{age + 1} years old."
