#!/usr/bin/env ruby
require "twitter"

a_poem = String.new(ARGV[0])

words = a_poem.split

noun_list = File.open('nounlist.txt').read

nouns = []

noun_list.each_line do |line|
  nouns << line.chomp
end

size_of_nouns = nouns.size

indices = Array.new(words.size, -1)

word_count = 0
words.each do |w|
  noun_count = 0
  nouns.each do |noun|  
    if w.gsub(/[.;:,]/,'') == noun
      indices[word_count] = ((noun_count+7)%size_of_nouns)
      break
    end
    noun_count = noun_count + 1
  end
  
  word_count = word_count + 1
end

a_new_poem = ""

count = 0
indices.each do |index|
  if index == -1
    a_new_poem << words[count]
  else
    a_new_poem << nouns[index]
  end

  a_new_poem << " "

  count = count + 1
end

puts a_new_poem


