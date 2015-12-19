module Hangman
  SAVE = "\u0013"

  class Game
    # The Game class handles gameplay flow
    attr_accessor :board, :player

    def initialize
      @board = Board.new
      @player = Player.new
    end

    def save_game
      saved_game = PStore.new("saved_game")
      saved_game.transaction do
        saved_game[:game] = self
      end
    end

    def load_game
      saved_game = PStore.new("saved_game")
      saved_game.transaction do
        if defined?(saved_game[:game])
          self.board = saved_game[:game].board
        end
      end
    end

    def welcome_msg
      puts %q{
________HANGMAN________
=======================
Options:
=======================
N: New Game
L: Load Game
Q: Quit
=======================}
    end

    def game_over_message
      if board.game_over == :win
        "\nYou won!"
      elsif board.game_over == :lose
        "\nYou died. The secret word was #{board.secret_word}."
      end
    end

    def options
      loop do
        case player.get_key
        when "n"
          puts "\nNew game!"
          play
          break
        when "l"
          puts "\nLoading saved game..."
          load_game
          play
          break
        when "q"
          puts "\nBye!"
          exit
        end
      end
    end

    def play
      loop do
        if board.game_over
          board.draw_board
          board.draw_guess
          puts game_over_message
          break
        end
        board.draw_board
        board.draw_guess
        board.draw_guessed_letters
        take_turn
      end
    end

    def play_again
      puts "\nPlay again? (y/n)"
      loop do
        input = player.get_key
        if input == "y"
          @board = Board.new
          play
          break
        elsif input == "n"
          puts "\nBye!\n"
          exit
        end
      end
    end

    def take_turn
      puts "\nGuess a letter or press 'ctrl-s' to save and quit:"
      player_input = player.get_key
      save_and_quit if player_input == SAVE
      board.guessed_letters << player_input
    end

    def save_and_quit
      save_game
      exit
    end
  end
end
