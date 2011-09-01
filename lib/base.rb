class Session

  attr_reader :store

  def initialize(many=10, types=:all, tree="/")
    @many = many   # How many questions asked
    @types = types # array of kinds of questions
    @tree = tree   # starting point in hierarchy
# STDOUT.puts "--- in base.rb: pwd = #{Dir.pwd}"
    @store = DataStore.open("store")
    if types == :all
      types = [Question, FIB, TF, MultipleChoice, Computed, PooledMultipleChoice]
    end
    @questions = @store.load_all(tree)
    @mcpools = @store.mcpools
    @questions.reject! {|x| ! types.include?(x.class) }
  end

  def start
    puts   #  Oops... not UI independent
    @questions.each do |ques|
      ques.ask
      ques.report
    end
    puts   #  Oops... not UI independent
  end
end

############

class Question     # superclass
  # Later: add stats like times missed, times correct, last asked, ...
  
  attr_accessor :topic
  attr_accessor :text, :correct_answer

  def initialize(text, correct_answer)
    @text, @correct_answer = text, correct_answer
    @response = nil
  end

  # UI must implement: ask, get_response, right?, wrong?, report

end

############

class FIB < Question    # maybe few/no changes?
end

############

class TF < Question     # true/false
end

############

class MultipleChoice < Question    
  # Later worry about: pooling, reordering or not, ...
  def initialize(text, correct_answer, *choices)
    super(text, correct_answer)
    @choices = choices
  end
end

############

class MCPool
  attr_reader :choices
  def initialize(name,options,choices)
    @name, @options, @choices = name, options, choices
  end
end

############

class PooledMultipleChoice < MultipleChoice # Question    
  # Later worry about: pooling, reordering or not, ...
  def initialize(text, correct_answer, pool)
    super(text, correct_answer)
    @pool = pool
  end
end

############

class Computed < Question    
  def initialize(code)
    @code = code
#   Must be evaluated when question is asked!
  end
end

