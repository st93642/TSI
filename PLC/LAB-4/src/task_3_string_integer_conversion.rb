#!/usr/bin/env ruby

$stdout.sync = true

def read_integer(prompt)
  loop do
    print prompt
    input = gets
    exit if input.nil?

    value = Integer(input.strip, exception: false)
    return value unless value.nil?

    puts 'Please enter a valid whole number.'
  end
end

def read_numeric_string(prompt)
  loop do
    print prompt
    input = gets
    exit if input.nil?

    value = input.strip
    return value unless Integer(value, exception: false).nil?

    puts 'Please enter a string that contains a valid whole number.'
  end
end

number = read_integer('Enter an integer to convert to a string: ')
number_as_string = number.to_s

numeric_string = read_numeric_string('Enter a numeric string to convert to an integer: ')
string_as_number = Integer(numeric_string, exception: false)

puts "Integer to string: #{number} -> \"#{number_as_string}\""
puts "String to integer: \"#{numeric_string}\" -> #{string_as_number}"
