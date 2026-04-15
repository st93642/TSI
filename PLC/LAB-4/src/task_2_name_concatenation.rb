#!/usr/bin/env ruby

$stdout.sync = true

def read_non_empty(prompt)
  loop do
    print prompt
    input = gets
    exit if input.nil?

    value = input.strip
    return value unless value.empty?

    puts 'Input must not be empty.'
  end
end

first_name = read_non_empty('Enter first name: ')
second_name = read_non_empty('Enter second name: ')
full_name = "#{first_name} #{second_name}"

puts "Concatenated string: #{full_name}"
