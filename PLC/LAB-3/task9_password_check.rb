#!/usr/bin/env ruby

require 'digest'
require 'io/console'

PASSWORD_SALT = 'lab3-ruby-salt'
PASSWORD_HASH = 'faeb6e294eae93f9ca188c6646122fab2b2b2d8bbc9f1078e4a40cb9feb2301a'

print 'Enter password: '
if STDIN.tty?
  password = STDIN.noecho(&:gets)
  puts
else
  password = gets
end

exit if password.nil?

entered_password = password.strip
entered_hash = Digest::SHA256.hexdigest("#{PASSWORD_SALT}#{entered_password}")

if entered_hash == PASSWORD_HASH
  puts 'Password is correct.'
else
  puts 'Password is incorrect.'
end

puts 'Security note: passwords should be stored as salted hashes and entered without displaying them on screen.'
