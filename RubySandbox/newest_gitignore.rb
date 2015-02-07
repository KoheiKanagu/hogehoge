require 'net/http'

LIST_FILE = 'gitignoreList'

puts 'Hello!'

unless File.exist?(LIST_FILE)
  puts '>> gitignoreList Not Found.'
  puts '>> Did make new file.'

  temp = <<-EOS
  # A sample newest_gitignore preference
  # https://github.com/github/gitignore
  #
  # Ruby.gitignore
  # Objective-C.gitignore
  EOS

  File.write(LIST_FILE, temp)
end

list = File.read(LIST_FILE).split("\n")

gitignore = ''

list.each do |variable|
  variable.strip!
  next if variable == ''
  next if /^#/ =~ variable

  gitignore << "# <<<<<<<< #{variable} >>>>>>>>\n"
  gitignore << "# <<<<<<<< by newest_gitignore.rb >>>>>>>>\n"

  url = 'https://raw.githubusercontent.com/github/gitignore/master/' + variable
  html = Net::HTTP.get(URI.parse(url))

  if html == 'Not Found'
    puts ">> #{variable} Not Found"
  else
    gitignore << html + "\n\n"
    puts '>> Done : ' + variable
  end
end

File.write('gitignore_global', gitignore)
puts 'Bye'
