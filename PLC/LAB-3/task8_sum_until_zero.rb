#!/usr/bin/env ruby

sum = 0

loop do
  print 'Enter a whole number (0 to stop): '
  input = gets&.strip
  exit if input.nil?

  value = Integer(input, exception: false)

  if value.nil? || value.negative?
    puts 'Please enter a valid whole number.'
    next
  end

  break if value.zero?

  sum += value
end

puts "Sum: #{sum}"
