#!/usr/bin/env ruby

def read_integer(prompt)
  loop do
    print prompt
    input = gets&.strip
    exit if input.nil?

    value = Integer(input, exception: false)
    return value unless value.nil?

    puts 'Please enter a valid integer.'
  end
end

first_number = read_integer('Enter the first integer: ')
second_number = read_integer('Enter the second integer: ')

product = first_number * second_number

puts "Product: #{product}"

if second_number.zero?
  puts 'Integer quotient: undefined (division by zero).'
else
  quotient = first_number.div(second_number)
  puts "Integer quotient (DIV): #{quotient}"
end
