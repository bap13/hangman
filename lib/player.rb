module Hangman
  class Player
    # The Player class handles user input
    def get_key
      letter = ""
      loop do
        letter = STDIN.getch
        break if letter.match(/[a-zA-Z | \u0013]/)
      end
      letter.downcase
    end
  end
end
