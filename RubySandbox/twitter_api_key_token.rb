require 'bundler'
Bundler.require

# Twitter API key and Tokens
class APIkeys
  TOML_FILE_PATH = 'TwitterAPIKeys.toml'

  def check_toml
    return true if File.exist?(TOML_FILE_PATH)
    puts '>> NotFound preference file. I made new file :D'
    File.write(TOML_FILE_PATH, TOML.dump(make_template))
    false
  end

  def make_template
    template = {
      'consumer_key' => '',
      'consumer_secret' => '',
      'access_token' => '',
      'access_token_secret' => '',
      'user' => ''
    }
    template
  end

  def check_consumer
    return false if load_consumer_key == ''
    return false if load_consumer_secret == ''
    true
  end

  def check_access
    return false if load_access_token == ''
    return false if load_access_token_secret == ''
    true
  end

  def check_keys
    return false if load_consumer_key == ''
    return false if load_consumer_secret == ''
    return false if load_access_token == ''
    return false if load_access_token_secret == ''
    true
  end

  def load_toml
    TOML.load_file(TOML_FILE_PATH)
  end

  def load_consumer_key
    doc = load_toml
    doc['consumer_key']
  end

  def load_consumer_secret
    doc = load_toml
    doc['consumer_secret']
  end

  def load_access_token
    doc = load_toml
    doc['access_token']
  end

  def load_access_token_secret
    doc = load_toml
    doc['access_token_secret']
  end

  def load_user
    doc = load_toml
    doc['user']
  end
end
