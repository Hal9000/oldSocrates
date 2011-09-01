require 'fileutils'
require 'find'
require 'yaml'

class DataStore

  attr_reader :root, :current, :current_full, :mcpools

  def self.create(root)
    @app_dir = Dir.pwd
    @root = root
    @current = "#@root"
    @current_full = "#@app_dir/#@root"
    if File.exist? @current_full
#   puts "DataStore.create: #@current_full already exists."
      FileUtils.rm_rf(@current_full)
    end
    FileUtils.mkdir_p(@current_full) 
    FileUtils.mkdir_p(@current_full+"/_mcpools") # underscore is special
    @mcpools = {}
    Dir.chdir(@current_full)
    @store = DataStore.new(root)
  end

  def self.open(root)
    @app_dir = Dir.pwd
    @root = root
    @current = "#@root"
    @current_full = "#@app_dir/#@root"
    if ! File.exist? @current_full
      raise "DataStore.open: #@current_full does not exist"
    end
    @mcpools = {}   # ???
    Dir.chdir(@current_full)
    @store = DataStore.new(root)
    @store.load_all(@current_full)
    @store
  end

  def initialize(root)
    @app_dir = Dir.pwd
    @root = root
    @current = "#@root"
    @current_full = "#@app_dir/#@root"
    if ! File.exist? @current_full
      FileUtils.mkdir_p(@current_full) 
      FileUtils.mkdir_p(@current_full+"/_mcpools") # underscore is special
    end
    @mcpools = {}
    Dir.chdir(@current_full)
  end

  def current_full
    real_path(@current)
  end

  def real_path(dir)
    result = 
    case dir
      when :top, "/", /^store/
	@app_dir+"/#@root"
      when /^\//  # absolute
	@app_dir + "/#@root" + dir
      else
	@current_full + "/" + dir
    end
#   puts "#{dir} => #{result}"
    result
  end

  def go_topic(dir)
    Dir.chdir(real_path(dir))
  rescue => err
    puts "Tried to go to: #{dir}"
    puts err
  end

  def load_all(dir)
    load_pools(dir)
    path = real_path(dir)
    list = []
    Find.find(path) {|x| list << x }
    pools = list.grep(/_mcpool/)
    list -= pools
    list = list.grep(/yaml$/).sort_by { rand }
    list.map {|x| YAML.load(File.read(x)) }
  end

  def load_pools(dir)
    path = real_path("#{dir}/_mcpool")
    files = []
    Find.find(path) {|x| files << x }
    files = files.grep(/yaml$/)
    pools = {}
    files.each do |file| 
      name = file.sub(/#{path}\//).sub(/.yaml$/)
      obj = YAML.load(File.read(file))
      pools[name] = obj
    end
    @mcpools[dir] = pools
  end

  def topic_exists?(dir)
    path = real_path(dir)
    return false if ! File.exist?(path)
    return false if ! File.directory?(path)
    true
  end

  def create_topic(dir,title=dir)
#   raise "Topic #{dir} already exists" if topic_exists?(dir)
    path = real_path(dir)
    FileUtils.mkdir_p(path) rescue nil
    File.open("#{path}/header","w") {|f| f.puts "#{title}\n0" }
    @current = dir
    @current_full = path
    Dir.chdir(path)
  rescue => err
    puts "Tried to create: #{dir}"
    puts err
  end

  def create_pool(name, options, items)
#   puts "Args: #{[name,options,items].inspect}"
# puts "cd into #{@current}"
    Dir.chdir(real_path(@current))
#   puts "curr = #@current"
    path = real_path(@current) + "/_mcpools"
    FileUtils.mkdir_p(path) rescue nil
    obj = MCPool.new(name,options,items)
    filename = "#{path}/#{name}.yaml"
# puts "filename = '#{filename}'"
    File.open(filename,"w") {|f| f.puts obj.to_yaml }
  rescue => err
    puts "Tried to create pool: #{filename}"
    puts err
  end

  def add_question(ques)
# puts "pwd = #{Dir.pwd}"
    head  = File.readlines("header")
    num  = head[1].to_i
    fname = "#{'%03d' % num}.yaml"
    File.open(fname,"w") {|f| f.puts ques.to_yaml }
    num += 1
    head[1] = num.to_s
    File.open("header","w") {|f| f.puts head }
  end

end

