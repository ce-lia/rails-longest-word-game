require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = (0...10).map { ('a'..'z').to_a[rand(26)] }
  end

  def score
    @score =
      if included?(params['word'], params['letters'])
        if english_word?(params['word'])
          "Congratulations! #{params['word'].capitalize} is a valid English word!"
        else
          "Sorry but #{params['word']} does not seem to be a valid English word..."
        end
      else
        "Sorry but #{params['word']} can't be built out of #{params['letters'].upcase}"
      end
  end

  def included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
