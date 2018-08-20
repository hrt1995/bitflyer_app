require 'net/http'
require 'uri'
require 'json'
require './key'
require "openssl"

def get_price

  uri = URI.parse("https://api.bitflyer.jp")
  uri.path = '/v1/getboard'
  uri.query = ''

  https = Net::HTTP.new(uri.host, uri.port)
  https.use_ssl = true
  response = https.get uri.request_uri
  response_hash = JSON.parse(response.body)
  response_hash["mid_price"]

end

def balance(coin_name)

  key = API_KEY
  secret = API_SECRET

  timestamp = Time.now.to_i.to_s
  method = "GET"
  uri = URI.parse("https://api.bitflyer.jp")
  uri.path = "/v1/me/getbalance"


  text = timestamp + method + uri.request_uri
  sign = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new("sha256"), secret, text)

  options = Net::HTTP::Get.new(uri.request_uri, initheader = {
    "ACCESS-KEY" => key,
    "ACCESS-TIMESTAMP" => timestamp,
    "ACCESS-SIGN" => sign,
  });

  https = Net::HTTP.new(uri.host, uri.port)
  https.use_ssl = true
  response = https.request(options)
  response_hash = JSON.parse(response.body)
  response_hash.find {|n| n["currency_code"] == coin_name}

end


def ifdoneOCO

  key = API_KEY
  secret = API_SECRET

  timestamp = Time.now.to_i.to_s
  method = "POST"
  uri = URI.parse("https://api.bitflyer.jp")
  uri.path = "/v1/me/sendparentorder"
  body = '{
  "order_method": "IFDOCO",
  "minute_to_expire": 10000,
  "time_in_force": "GTC",
  "parameters": [{
    "product_code": "BTC_JPY",
    "condition_type": "LIMIT",
    "side": "BUY",
    "price": 450000,
    "size": 0.001
  },
  {
    "product_code": "BTC_JPY",
    "condition_type": "LIMIT",
    "side": "SELL",
    "price": 460000,
    "size": 0.001
  },
  {
    "product_code": "BTC_JPY",
    "condition_type": "STOP_LIMIT",
    "side": "SELL",
    "price": 445000,
    "trigger_price": 29000,
    "size": 0.001
  }]
}'

  text = timestamp + method + uri.request_uri + body
  sign = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new("sha256"), secret, text)

  options = Net::HTTP::Post.new(uri.request_uri, initheader = {
    "ACCESS-KEY" => key,
    "ACCESS-TIMESTAMP" => timestamp,
    "ACCESS-SIGN" => sign,
    "Content-Type" => "application/json"
  });
  options.body = body

  https = Net::HTTP.new(uri.host, uri.port)
  https.use_ssl = true
  response = https.request(options)
  puts response.body
end
