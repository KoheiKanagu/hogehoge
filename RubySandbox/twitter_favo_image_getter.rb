require './twitter_api_key_token.rb'
require 'net/http'
require 'open-uri'
require 'parallel'
require 'thread'

require 'bundler'
Bundler.require

def scan_image_urls(url)
  html = Net::HTTP.get(URI.parse(url))
  array = html.scan(/<img src="(.*)" alt.*width.*height.*>/)
  array
end

def save_data(url, dir)
  filepath = dir + File.basename(url)
  Dir.mkdir(dir) unless File.exist?(dir)
  open(filepath, 'wb') do |output|
    open(url) do |data|
      output.write(data.read)
    end
  end
end

SEARCH_FAVO_COUNT = 200 # less than or equal to 200
puts '>> Hello!'

api = APIkeys.new
exit unless api.check_toml
unless api.check_keys
  puts '>> Incomplete key or token.'
  exit
end

client = Twitter::REST::Client.new do |config|
  config.consumer_key = api.load_consumer_key
  config.consumer_secret = api.load_consumer_secret
  config.access_token = api.load_access_token
  config.access_token_secret = api.load_access_token_secret
end

dir = 'image/'
hoge = client.favorites(api.load_user, count: SEARCH_FAVO_COUNT)

Parallel.map(hoge, in_threads: 2) do |item|
  next unless item.is_a?(Twitter::Tweet)
  array = scan_image_urls(item.url)
  count = 0

  array.each do |url|
    save_data(url[0], dir)
    count += 1
    puts "[#{count}/#{array.count}] #{url[0]}"
  end
end
puts '>> Bey'
