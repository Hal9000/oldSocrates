@store = DataStore.new

def create_topic(*args)
  @store.create_topic(*args)  # implies this is now current one
end

def question(*args)
  obj = Question.new(*args)
  @store.add_question(obj)
end

def fib(*args)
  obj = FIB.new(*args)
  @store.add_question(obj)
end

def tf(*args)
  obj = TF.new(*args)
  @store.add_question(obj)
end

def mchoice(*args)
  obj = MultipleChoice.new(*args)
  @store.add_question(obj)
end

def computed(*args,&block)
  obj = Computed.new(*args,&block)
  @store.add_question(obj)
end

