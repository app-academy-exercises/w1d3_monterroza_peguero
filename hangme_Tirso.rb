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

    puts self.mistakes >= 10 ? "Guesser lost..." : "Guesser won!"
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
    !self.word_state.include?(".")
  end

  def word_state
    @word_state ||= ["."] * self.checker.pick_word
  end
end

class HumanPlayer
  def guess(word_state)
    loop do
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
    gets.chomp.split(',').map{|val| Integer(val) - 1}
  end

  def pick_word
    print "What is the length of your word?"
    gets.chomp.to_i
  end
end

class ComputerPlayer
  attr_accessor :dict_arr, :word, :poss_words, :guessed_letters, :word_state

  def initialize(dict_file)
    @dict_arr = File.readlines(dict_file).select do |word|
      !word.include?("-") && !word.include?("'")
    end.map(&:chomp)
  end

  def guessed_letters
    @guessed_letters ||= []
  end

  def guess(word_state)
    # MUST be called first
    self.word_state = word_state

    # Must be called after
    p letters = poss_guesses(word_state)
    vowels = %w[ a e i o u ] & letters
    if vowels.size > 0
      (self.guessed_letters << vowels.sample).last
    else
      (self.guessed_letters << letters.sample).last
    end
  end

  def poss_guesses(word_state)
    self.poss_words = self.poss_words.select { |i| i =~ Regexp.new(word_state.join) }

    self.poss_words.join.split("").uniq - self.guessed_letters
  end

  def poss_words
    @poss_words ||= self.dict_arr.select do |word|
      word.length == self.word_state.size
    end
  end

  def check(char)
    [].tap do |index_array|
      self.word.each_with_index do |val, index|
        index_array << index if val == char
      end
    end
  end

  def pick_word
    self.word.length
  end

  def word
    p @word ||= self.dict_arr.sample.split("")
  end
end

Hangman.new(checker: HumanPlayer.new, guesser: ComputerPlayer.new("dictionary.txt")).play

# Hangman.new().play