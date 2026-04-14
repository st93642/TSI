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

def read_conversion_choice
  loop do
    print "Convert from C to F or from F to C? Enter 'C' or 'F': "
    input = gets&.strip&.upcase
    exit if input.nil?

    return input if %w[C F].include?(input)

    puts "Please enter 'C' or 'F'."
  end
end

temperature = read_float('Enter the temperature value: ')
choice = read_conversion_choice

if choice == 'C'
  converted_temperature = (temperature * 9.0 / 5.0) + 32
  puts format('%.2f C = %.2f F', temperature, converted_temperature)
else
  converted_temperature = (temperature - 32) * 5.0 / 9.0
  puts format('%.2f F = %.2f C', temperature, converted_temperature)
end
