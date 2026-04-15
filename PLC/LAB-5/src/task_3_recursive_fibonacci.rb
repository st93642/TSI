#!/usr/bin/env ruby

$stdout.sync = true

def fibonacci(index)
  return index if index < 2

  fibonacci(index - 1) + fibonacci(index - 2)
end

puts 'Fibonacci sequence from F(0) to F(10):'

(0..10).each do |index|
  puts "F(#{index}) = #{fibonacci(index)}"
end
