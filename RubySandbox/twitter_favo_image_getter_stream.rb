require './twitter_api_key_token.rb'
require 'net/http'
require 'open-uri'
require 'parallel'
require 'thread'

require 'bundler'
Bundler.require

def scan_image_urls(url)
  html = Net::HTTP.get(URI.parse(url))
  array = html.scan(/<img src="(.*)".*(?:alt=|style=).*>/)
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

def save_images(save_dir, source_url)
  images = scan_image_urls(source_url)
  images.each do |url|
    save_data(url[0], save_dir)
    puts url[0]
  end
end

puts '>> Hello!'

api = APIkeys.new
exit unless api.check_toml
unless api.check_keys
  puts '>> Incomplete key or token.'
  exit
end

client = Twitter::Streaming::Client.new do |config|
  config.consumer_key = api.load_consumer_key
  config.consumer_secret = api.load_consumer_secret
  config.access_token = api.load_access_token
  config.access_token_secret = api.load_access_token_secret
end

client.user do |object|
  case object
  when Twitter::Streaming::Event
    if object.name == 'favorite'.to_sym
      save_images('image/', object.target_object.url)
    end
  end
end

puts '>> Bey'
