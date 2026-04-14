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

a = read_float('Enter coefficient a: ')
b = read_float('Enter coefficient b: ')
c = read_float('Enter coefficient c: ')

if a.zero?
  puts 'Coefficient a must not be zero for a quadratic equation.'
  exit
end

discriminant = (b * b) - (4 * a * c)

puts format('Discriminant: %.3f', discriminant)

if discriminant.negative?
  puts 'The equation has no real roots.'
elsif discriminant.zero?
  root = -b / (2.0 * a)
  puts format('x1 = x2 = %.3f', root)
else
  sqrt_discriminant = Math.sqrt(discriminant)
  first_root = (-b + sqrt_discriminant) / (2.0 * a)
  second_root = (-b - sqrt_discriminant) / (2.0 * a)

  puts format('x1 = %.3f', first_root)
  puts format('x2 = %.3f', second_root)
end
