#!/usr/bin/env ruby

$stdout.sync = true

def read_real(prompt)
  loop do
    print prompt
    input = gets
    exit if input.nil?

    value = Float(input.strip, exception: false)
    return value unless value.nil?

    puts 'Please enter a valid number.'
  end
end

def format_number(number)
  return number.to_i.to_s if number == number.to_i

  format('%.2f', number)
end

def square_by_value(number)
  number * number
end

def square_by_reference(number_holder)
  number_holder[0] *= number_holder[0]
end

input_number = read_real('Enter a number: ')

value_argument = input_number
value_result = square_by_value(value_argument)

reference_argument = [input_number]
square_by_reference(reference_argument)

puts "Original number: #{format_number(input_number)}"
puts "square_by_value result: #{format_number(value_result)}"
puts "Argument after square_by_value: #{format_number(value_argument)}"
puts "Argument after square_by_reference: #{format_number(reference_argument[0])}"
