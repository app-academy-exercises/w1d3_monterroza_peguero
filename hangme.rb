class Hangman
  attr_accessor :guesser, :checker, :word_state, :mistakes

  def initialize(options = {})
    self.guesser = options[:guesser] || HumanPlayer.new
    self.checker = options[:checker] || ComputerPlayer.new("dictionary.txt")
  end

  def play
    until won? || self.mistakes == 10 do

      char = self.guesser.guess(self.word_state)

      index_array = self.checker.check(char)

      if index_array.length != 0
        update_word_state(char, index_array)
      else
        self.mistakes += 1
      end

      print_state
    end

    puts self.mistakes >= 10 ? "You've lost..." : "You've won!"
  end

  def mistakes
    @mistakes ||= 0
  end

  def update_word_state(char, index_array)
    index_array.each do |val|
      self.word_state[val] = char
    end
  end

  def print_state
    puts word_state.join(", ")
    puts "Current Mistakes: #{self.mistakes}"
  end

  def won?
    !self.word_state.include?("_")
  end

  def word_state
    @word_state ||= ["_"] * self.checker.pick_word
  end
end

class HumanPlayer
  def guess(word_size)
    while true do
      puts "What LETTER do you want to guess?"

      var = gets.chomp.downcase
      if var.length == 1 || ('a'..'z').to_a.include?(var)
        return var
      else
        puts "Hey ONE (1) ALPHABETIC LETTER!"
      end
    end
  end

  def check(char)
    puts "Human, enter any indices that match this letter (separated by commmas): #{char}"
    puts "[Just hit ENTER if none.]"
    gets.chomp.split(',').map(&:to_i)
  end

  def pick_word
    print "What is the length of your word?"
    gets.chomp.to_i
  end
end

class ComputerPlayer
  attr_accessor :dict_arr, :word, :word_size, :poss_words

  def initialize(dict_file)
    @dict_arr = File.readlines(dict_file).select { |word|
      !word.include?("-")
    }.map(&:chomp)
  end

  def guess(word_size)
    self.word_size = word_size
    self.poss_guesses.pop
  end

  def word_size=(word_size)
    if !@word_size
      @word_size = word_size

      p self.poss_words = self.dict_arr.select { |word|
        word.length == word_size
      }

      p self.poss_words.length
    end
  end

  def smart_guess(word_size)

  end

  def poss_guesses
    @poss_guesses ||= ('a'..'z').to_a.shuffle
  end

  def poss_words
    @poss_words ||= []
  end

  def check(char)
    index_array = []
    self.word.each_with_index do |val, index|
      index_array << index if val == char
    end

    index_array
  end

  def pick_word
    self.word.length
  end

  def word
    p @word ||= self.dict_arr.sample.split("")
  end
end

Hangman.new(checker: HumanPlayer.new(), guesser: ComputerPlayer.new("dictionary.txt")).play

# Hangman.new().play