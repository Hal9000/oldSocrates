require 'fileutils'
require 'find'
require 'yaml'

class DataStore
  def initialize
    @app_dir = Dir.pwd
    @root = "store"
    @current = "#@app_dir/#@root"
    if ! File.exist? @current
      FileUtils.mkdir_p(@current) 
      FileUtils.mkdir_p(@current+"/_mcpools") # underscore is special
    end
    Dir.chdir(@current)
  end

  def real_path(dir)
    case dir
      when :top, "/"
	@app_dir+"/#@root"
      when /^\//  # absolute
	@app_dir + "/#@root" + dir
      else
	@current + "/" + dir
    end
  end

  def go_topic(dir)
    Dir.chdir(real_path(dir))
  rescue => err
    puts "Tried to go to: #{dir}"
    puts err
  end

  def load_all(dir)
    # ignore mc pools for now
    path = real_path(dir)
    list = []
    Find.find(path) {|x| list << x }
    list = list.grep(/yaml$/).sort_by { rand }
    list.map {|x| YAML.load(File.read(x)) }
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
    Dir.chdir(path)
  rescue => err
    puts "Tried to create: #{dir}"
    puts err
  end

  def add_question(ques)
    head  = File.readlines("header")
    num  = head[1].to_i
    fname = "#{'%03d' % num}.yaml"
    File.open(fname,"w") {|f| f.puts ques.to_yaml }
    num += 1
    head[1] = num.to_s
    File.open("header","w") {|f| f.puts head }
  end

end

