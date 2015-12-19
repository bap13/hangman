module Hangman
  DICTIONARY = File.readlines("5desk.txt").map(&:chomp)

  class Board
    # The Board class maintains the hangman gameboard
    attr_accessor :secret_word, :guessed_letters

    def initialize
      @secret_word = new_word
      @guessed_letters = []
    end

    def new_word
      DICTIONARY.select do |word|
        word.length.between?(5, 12)
      end.sample.downcase
    end

    def game_over
      return :win if win?
      return :lose if lose?
    end

    def win?
      !!secret_word.match(/^["#{guessed_letters.join}"]+$/)
    end

    def lose?
      incorrect_letters.size >= 6
    end

    def incorrect_letters
      secret_chars = secret_word.chars
      guessed_letters.map.select do |letter|
        !secret_chars.include?(letter)
      end.uniq
    end

    def draw_board
      shrug = "\u30C4".encode
      hand = "\u203E".encode
      case incorrect_letters.size
      when 0
        puts %q{
          ______
          |    |
          |
          |
          |
          |
          |
          |
          #~~~~~~~~~}
      when 1
        puts %Q{
          ______
          |    |
          |   (#{shrug})
          |
          |
          |
          |
          |
          #~~~~~~~~~}
      when 2
        puts %Q{
          ______
          |    |
          |   (#{shrug})
          |    |
          |    |
          |
          |
          |
          #~~~~~~~~~}
      when 3
        puts %Q{
          ______
          |    |
          |   (#{shrug})
          |    |_/#{hand}
          |    |
          |
          |
          |
          #~~~~~~~~~}
      when 4
        puts %Q{
          ______
          |    |
          |   (#{shrug})
          | #{hand}\\_|_/#{hand}
          |    |
          |
          |
          |
          #~~~~~~~~~}
      when 5
        puts %Q{
          ______
          |    |
          |   (#{shrug})
          | #{hand}\\_|_/#{hand}
          |    |
          |     \\
          |      \\
          |
          #~~~~~~~~~}
      when 6
        puts %Q{
          ______
          |    |
          |   (#{shrug})
          | #{hand}\\_|_/#{hand}
          |    |
          |   / \\
          |  /   \\
          |
          #~~~~~~~~~}
      end
    end

    def draw_guess
      guess = secret_word.each_char.map do |c|
        guessed_letters.include?(c) ? c : "-"
      end.join.rjust(20, " ")
      puts "\n" + guess
    end

    def draw_guessed_letters
      puts "\nGuessed letters: #{guessed_letters.uniq.join(", ")}"
    end
  end
end
