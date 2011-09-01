require 'base'
require 'datastore'

@store = DataStore.create("store")
# p "@store = #@store"

def create_topic(*args)
  @store.create_topic(*args)  # implies this is now current one
end

def create_mcpool(*args)
  args = args.dup
  name = args.shift
  options = []
  loop do
    if args.first.is_a? Symbol
      options << args.shift 
    else
      break
    end
  end
# p [name, options, args]
  @store.create_pool(name,options,args)
end

def question(*args)
  obj = Question.new(*args)
  obj.topic = @store.current
  @store.add_question(obj)
end

def fib(*args)
  obj = FIB.new(*args)
  obj.topic = @store.current
  @store.add_question(obj)
end

def tf(*args)
  obj = TF.new(*args)
  obj.topic = @store.current
  @store.add_question(obj)
end

def mchoice(*args)
  obj = MultipleChoice.new(*args)
  obj.topic = @store.current
  @store.add_question(obj)
end

def pmchoice(*args)
  obj = PooledMultipleChoice.new(*args)
  obj.topic = @store.current
  @store.add_question(obj)
end

def computed(*args,&block)
  obj = Computed.new(*args,&block)
  obj.topic = @store.current
  @store.add_question(obj)
end

