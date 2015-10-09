#!/usr/bin/env ruby
require "twitter"

a_poem = String.new(ARGV[0])

words = a_poem.split

words.each do |w|
  puts "A word : " + w
end


puts a_poem


