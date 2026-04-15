#!/usr/bin/env ruby

$stdout.sync = true

MATRIX_SIZE = 4

def read_matrix_row(row_number)
  loop do
    print "Enter row #{row_number} (#{MATRIX_SIZE} whole numbers separated by spaces): "
    input = gets
    exit if input.nil?

    values = input.split.map { |token| Integer(token, exception: false) }
    return values if values.length == MATRIX_SIZE && values.none?(&:nil?)

    puts "Please enter exactly #{MATRIX_SIZE} whole numbers separated by spaces."
  end
end

matrix = Array.new(MATRIX_SIZE) { |index| read_matrix_row(index + 1) }
total = matrix.flatten.sum

puts 'Matrix:'
matrix.each do |row|
  puts row.map { |value| format('%4d', value) }.join(' ')
end
puts "Sum of all elements: #{total}"
