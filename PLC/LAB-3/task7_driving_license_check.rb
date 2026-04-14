#!/usr/bin/env ruby

def read_integer(prompt)
  loop do
    print prompt
    input = gets&.strip
    exit if input.nil?

    value = Integer(input, exception: false)
    return value if !value.nil? && value >= 0

    puts 'Please enter a valid non-negative integer.'
  end
end

age = read_integer('Enter your age: ')

if age >= 18
  puts 'You are of legal age to apply for a driving license.'
else
  years_remaining = 18 - age
  puts "You can apply for a driving license in #{years_remaining} year(s)."
end
