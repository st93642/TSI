#!/usr/bin/env ruby

$stdout.sync = true

def read_real(prompt)
  loop do
    print prompt
    input = gets
    exit if input.nil?

    value = Float(input.strip, exception: false)
    return value unless value.nil?

    puts 'Please enter a valid real number.'
  end
end

def format_number(number)
  return number.to_i.to_s if number == number.to_i

  format('%.2f', number)
end

def maximum(first, second, third)
  puts "Maximum value: #{format_number([first, second, third].max)}"
end

first = read_real('Enter first real number: ')
second = read_real('Enter second real number: ')
third = read_real('Enter third real number: ')

maximum(first, second, third)
