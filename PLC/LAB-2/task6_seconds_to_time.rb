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

total_seconds = read_integer('Enter the number of seconds: ')
hours, remaining_seconds = total_seconds.divmod(3600)
minutes, seconds = remaining_seconds.divmod(60)

puts "#{total_seconds} second(s) = #{hours} hour(s), #{minutes} minute(s), #{seconds} second(s)."
