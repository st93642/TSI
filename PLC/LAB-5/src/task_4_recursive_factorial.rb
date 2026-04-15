#!/usr/bin/env ruby

$stdout.sync = true

def read_non_negative_integer(prompt)
  loop do
    print prompt
    input = gets
    exit if input.nil?

    value = Integer(input.strip, exception: false)
    return value if !value.nil? && value >= 0

    puts 'Please enter a non-negative whole number.'
  end
end

def factorial(number)
  return 1 if number.zero?

  number * factorial(number - 1)
end

number = read_non_negative_integer('Enter a non-negative integer: ')
puts "Factorial of #{number} is #{factorial(number)}"
