require './twitter_api_key_token.rb'

require 'bundler'
Bundler.require

api = APIkeys.new
exit unless api.check_toml
unless api.check_consumer
  puts '>> Incomplete consumer key or secret.'
  exit
end

consumer_key = api.load_consumer_key
consumer_secret = api.load_consumer_secret

consumer = OAuth::Consumer.new consumer_key, consumer_secret, site: 'https://api.twitter.com'

request_token = consumer.get_request_token

puts "Please visit here: #{request_token.authorize_url}"
STDERR.print 'Then put your PIN: '

access_token = request_token.get_access_token oauth_verifier: gets.chomp
puts "Token: #{access_token.token}"
puts "Secret: #{access_token.secret}"
