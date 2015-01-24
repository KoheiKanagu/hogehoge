require './toml_ctrl.rb'
require './keys.rb'

@toml = TomlController.new

def help
  puts ">> \'init\' <- Initialize TOML file"
  puts ">> \'del\' <- Delete TOML file"
  puts ">> \'show\' <- Show remove file path"
  puts ">> \'set\' <- Set remove file path"
  puts ">> \'do\' <- Do processing"
  puts ">> \'help\' <- Show command sheet"
  puts ">> \'quit\' <- exit"
end

def show_path
  path = @toml.load_item(Keys::PATH_KEY)
  puts ">> \'path\' :" + path
end

def set_path
  puts '>> Input Path'
  string = gets_string
  @toml.write_item(Keys::PATH_KEY, string)
end

def gets_string
  loop do
    print ':'
    string = gets.chomp
    break string unless string == ''
  end
end

def remove_file(path)
  rm = system("rm -r #{path}")
  puts '>> Deleted.' if rm
end

puts '>> Hello!!'
help
loop do
  print "\n:"
  case gets.chomp
  when 'init'
    @toml.init_file
  when 'del'
    @toml.del_file
  when 'show'
    show_path if @toml.exist_file
  when 'set'
    if @toml.exist_file
      set_path
      puts '>> Done.'
    end
  when 'do'
    path = @toml.load_item(Keys::PATH_KEY)
    unless path.nil?
      if path == 'nil'
        puts '>> File path is unset.'
      else
        remove_file(path)
      end
    end
  when 'help'
    help
  when 'quit'
    puts '>> Bye.'
    break
  else
    puts '>> Unknown command'
  end
end
