#!/usr/bin/env ruby

$stdout.sync = true

print 'Enter a string: '
input = gets
exit if input.nil?

text = input.chomp

puts "String: #{text}"
puts "Length: #{text.length}"
