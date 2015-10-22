#!/usr/bin/env ruby
require "twitter"

class NPlus
  @@nouns = []

  def self.seven(a_poem)
    words = a_poem.split

    if @@nouns.empty?
      noun_list = File.open('nounlist.txt').read

      noun_list.each_line do |line|
        @@nouns << line.chomp
      end
    end

    size_of_nouns = @@nouns.size

    indices = Array.new(words.size, -1)

    word_count = 0
    words.each do |w|
      noun_count = 0
      @@nouns.each do |noun|  
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
        a_new_poem << @@nouns[index]
      end
      
      a_new_poem << " "
      
      count = count + 1
    end
    
    return a_new_poem
  end
end

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV['CONSUMER_KEY']
  config.consumer_secret     = ENV['CONSUMER_SECRET']
  config.access_token        = ENV['ACCESS_TOKEN']
  config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
end

client.search("clock").take(3).each do |tweet|
  puts tweet.id
  puts tweet.full_text
  puts tweet.text

  a_new_tweet = NPlus.seven(tweet.text)

  if a_new_tweet != tweet.text
    rt = "MT @#{tweet.user.screen_name}: #{a_new_tweet}"
  
    puts rt
    puts rt[0,140]
    puts "------------------------------------------------------"
    client.update(rt[0,140])
  end
end

