require 'bundler'
Bundler.require
require './keys.rb'

# Controll of TOML file
class TomlController
  def init_file
    doc = template_toml_file

    if File.exist?(Keys::TOML_KEY)
      puts '>> TOML file is already. Override by New file? (y/n)'
      unless ask_y_n
        puts '>> ok. Keep this file.'
        return
      end
    end
    write_toml_file(doc)
    puts '>> TOML file write completed.'
  end

  def del_file
    return unless exist_file
    puts '>> Delete TOML file? (y/n)'
    if ask_y_n
      rm = `#{'rm ' + Keys::TOML_KEY}`
      puts '>> Deleted.' if rm == ''
    else
      puts '>> ok. Keep this file.'
    end
  end

  def load_item(key)
    return unless exist_file
    doc = TOML.load_file(Keys::TOML_KEY)
    if doc[key] == ''
      'nil'
    else
      doc[key]
    end
  end

  def write_item(key, item)
    return unless exist_file
    doc = TOML.load_file(Keys::TOML_KEY)
    doc[key] = item
    File.write(Keys::TOML_KEY, TOML.dump(doc))
  end

  def exist_file
    if File.exist?(Keys::TOML_KEY)
      true
    else
      puts '>> TOML file is not found. Need make new file.'
      false
    end
  end

  private

  def ask_y_n
    print ':'
    loop do
      case gets.chomp.downcase
      when 'y'
        break true
      when 'n'
        break false
      else puts '>> (y/n)'
      end
    end
  end

  def template_toml_file
    <<-EOS
    title = "FileRemover Preference"
    path = ""
    EOS
  end

  def write_toml_file(doc)
    File.write(Keys::TOML_KEY, doc)
  end
end
