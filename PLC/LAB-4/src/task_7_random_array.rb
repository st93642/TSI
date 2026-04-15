#!/usr/bin/env ruby

$stdout.sync = true

ARRAY_SIZE = 40
MIN_VALUE = 0
MAX_VALUE = 9
COLUMN_COUNT = 5

seed_text = ENV['LAB4_RANDOM_SEED']
seed = Integer(seed_text, exception: false)
rng = seed.nil? ? Random.new : Random.new(seed)

numbers = Array.new(ARRAY_SIZE) { rng.rand(MIN_VALUE..MAX_VALUE) }

puts "Generated #{ARRAY_SIZE} random integers in range #{MIN_VALUE}..#{MAX_VALUE}:"
numbers.each_slice(COLUMN_COUNT) do |row|
  puts row.map { |value| format('%3d', value) }.join(' ')
end
puts "Seed: #{seed}" unless seed.nil?
