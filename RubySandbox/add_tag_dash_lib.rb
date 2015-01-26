#dashのスニペットのsyntaxに応じて、titleの先頭にタグを付与

require 'sqlite3'

db = SQLite3::Database.new('library.dash')
db.execute('SELECT sid, title, syntax FROM snippets') do |row|
  old_title = row[1]
  new_title = nil

  case row[2]
  when 'Objective-C'
    new_title = "[Obj-C] #{old_title}"
  when 'LaTeX'
    new_title = "[LaTeX] #{old_title}"
  end

  unless new_title.nil?
    puts "#{row[0]} : #{new_title}}"
    db.execute("UPDATE snippets SET title = '#{new_title}' WHERE sid = #{row[0]}")
  end
end
db.close
