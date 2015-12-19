require_relative '../lib/hangman.rb'

game = Hangman::Game.new
loop do
  puts game.welcome_msg
  game.options
  game.play_again
end
