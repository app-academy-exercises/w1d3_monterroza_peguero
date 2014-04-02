class Game
  #guesses are split strings: "GRBY" = ["R", "G", "B", "Y"]

  attr_accessor :guesses, :master_code, :guess_code, :results

  def play
    until won? || self.guesses == 10 do
      get_guess
      evaluate_guess
      self.guesses += 1
      pretty_print
    end
    puts self.guesses >= 10 ? "You've lost..." : "You've won!"
  end

  def won?
    self.results.first == 4
  end

  def guesses
    @guesses ||= 0
  end

  def master_code
    p @master_code ||= Code.random
  end

  def results
    @results ||= [0,0]
  end

  def pretty_print #[0,0]
    exact_guesses, close_guesses = self.results

    puts "Exact guesses: #{exact_guesses}"
    puts "Close guesses: #{close_guesses}"
    puts "You have #{10 - self.guesses} left."
  end

  def get_guess
    puts "What's your guess?"
    self.guess_code = Code.parse
  end

  def evaluate_guess
    self.master_code.each_with_index do |val, index|
      self.results[0] += 1 if (val == self.guess_code[index])
    end

    self.results[1] = (self.master_code & self.guess_code).count - results.first
  end

end

class Code
  POSSIBILITIES = "RGBYOP".split("")

  def self.parse()
    valid = false
    until valid do
      response = gets.chomp().upcase.split("")

      if ((response & POSSIBILITIES).count != 4) || (response.count != 4)
        puts "Provide a set of 4 of the following characters (No Repeats): #{POSSIBILITIES}"
      else
        valid = true
      end
    end

    response
  end

  def self.random
    POSSIBILITIES.shuffle[0..3]
  end

end

Game.new().play