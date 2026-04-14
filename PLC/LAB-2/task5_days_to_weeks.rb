#!/usr/bin/env ruby

def read_integer(prompt)
  loop do
    print prompt
    input = gets&.strip
    exit if input.nil?

    value = Integer(input, exception: false)
    return value if !value.nil? && value >= 0

    puts 'Please enter a valid non-negative integer.'
  end
end

total_days = read_integer('Enter the number of days: ')
weeks, days = total_days.divmod(7)

puts "#{total_days} day(s) = #{weeks} week(s) and #{days} day(s)."
