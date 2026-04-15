#!/usr/bin/env ruby

$stdout.sync = true

def read_positive_integer(prompt)
  loop do
    print prompt
    input = gets
    exit if input.nil?

    value = Integer(input.strip, exception: false)
    return value if !value.nil? && value.positive?

    puts 'Please enter a positive whole number.'
  end
end

def read_number(prompt)
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

element_count = read_positive_integer('Enter number of elements: ')
numbers = Array.new(element_count) do |index|
  read_number("Enter element #{index + 1}: ")
end

reversed_numbers = numbers.reverse
average = numbers.sum / numbers.length

puts "Array: #{numbers.map { |number| format_number(number) }.join(', ')}"
puts "Reversed array: #{reversed_numbers.map { |number| format_number(number) }.join(', ')}"
puts format('Average: %.2f', average)
