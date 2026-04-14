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

def read_result_mode
  loop do
    print "Choose result type ('rounded' or 'truncated'): "
    input = gets&.strip&.downcase
    exit if input.nil?

    return input if %w[rounded truncated].include?(input)

    puts "Please type 'rounded' or 'truncated'."
  end
end

first_number = read_float('Enter the first real number: ')
second_number = read_float('Enter the second real number: ')
result_mode = read_result_mode

product = first_number * second_number

puts format('Exact product: %.4f', product)

if result_mode == 'rounded'
  puts "Rounded product: #{product.round}"
else
  puts "Truncated product: #{product.truncate}"
end
