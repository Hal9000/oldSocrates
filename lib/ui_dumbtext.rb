class Question

  def ask          # GUI would just grab @text...
    puts @text
    get_response
  end

  def get_response
    @response = gets.chomp
    raise unless validate
  rescue
    puts "Empty response!"
    retry
  end

  def validate
    @response.strip != ""
  end

  def right?
    @response == correct_answer
  end

  def wrong?
    @response != correct_answer
  end

  def report
    if right?
      puts "Right!"
    else
      puts "Wrong - answer was #@correct_answer"
    end
    puts
  end

end

############

class FIB < Question
end

############

class TF < Question

  Chars = {"T" => true, "t" => true, "F" => false, "f" => false }

  def ask
    puts "T/F: #@text"
    get_response
  end

  def get_response
    @response = Chars[gets.chomp]
    raise unless validate
  rescue
    puts "Please respond with T or F."
    retry
  end

  def validate
    ! @response.nil?
  end

  def report
    if right?
      puts "Right!"
    else
      puts "Wrong"
    end
    puts
  end

end


############

class MultipleChoice < Question    
  def ask
    puts @text
    label = "a"
    @labels = {}
    @choices.each do |c| 
      @labels[label] = c
      puts "  #{label}. #{c}"
      label = label.succ
    end
    STDOUT.print "=> "
    STDOUT.flush
    get_response
  end

  def get_response
    char = gets.chomp
    @response = @labels[char]
    raise unless validate
  rescue
    puts "#{char} is not one of #{@labels.keys.join(' ')}"
    retry
  end

  def validate
    ! @response.nil?
  end
end

############

class PooledMultpleChoice < Question    
end

############

class Computed

  def ask
    @text, @correct_answer = eval("lambda { #@code }").call
    super
  end

end
