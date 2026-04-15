#!/usr/bin/env ruby

$stdout.sync = true

MONTH_NAMES = %w[
  January February March April May June
  July August September October November December
].freeze

def read_integer(prompt)
  loop do
    print prompt
    input = gets
    exit if input.nil?

    value = Integer(input.strip, exception: false)
    return value unless value.nil?

    puts 'Please enter a valid whole number.'
  end
end

def leap_year?(year)
  (year % 400).zero? || ((year % 4).zero? && !(year % 100).zero?)
end

def days_in_month(month, year)
  case month
  when 1, 3, 5, 7, 8, 10, 12
    31
  when 4, 6, 9, 11
    30
  when 2
    leap_year?(year) ? 29 : 28
  else
    0
  end
end

def ordinal_suffix(day)
  return 'th' if (11..13).cover?(day % 100)

  case day % 10
  when 1
    'st'
  when 2
    'nd'
  when 3
    'rd'
  else
    'th'
  end
end

day = read_integer('Enter day: ')
month = read_integer('Enter month: ')
year = read_integer('Enter year: ')

if year <= 0
  puts 'Invalid date: year must be greater than 0.'
  exit 1
end

unless (1..12).cover?(month)
  puts 'Invalid date: month must be between 1 and 12.'
  exit 1
end

max_day = days_in_month(month, year)

unless (1..max_day).cover?(day)
  puts "Invalid date: day #{day} is not valid for #{MONTH_NAMES[month - 1]} #{year}."
  exit 1
end

puts "Formatted date: #{day}#{ordinal_suffix(day)} #{MONTH_NAMES[month - 1]} #{year}"
