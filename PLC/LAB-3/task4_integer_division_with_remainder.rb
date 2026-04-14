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

dividend = read_integer('Enter the first integer: ')
divisor = read_integer('Enter the second integer: ')

if divisor.zero?
  puts 'Division by zero is not allowed.'
  exit
end

quotient, remainder = dividend.divmod(divisor)

puts "#{dividend}/#{divisor} = #{quotient} remainder #{remainder}"
