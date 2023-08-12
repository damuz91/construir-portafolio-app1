require 'bundler'; Bundler.require
require 'net/http'
require 'json'
require 'sinatra'
require "sinatra/cors"

set :allow_origin, "*"
set :allow_methods, "GET"

get '/weather' do
  # https://weatherstack.com/documentation
  content_type :json
  base_url = 'http://api.weatherstack.com'
  method = '/current'
  api_key = 'xxx'
  location = params[:location]

  url = "#{base_url}#{method}?access_key=#{api_key}&query=#{location}"
  
  url = URI.parse(url)
  http = Net::HTTP.new(url.host, url.port)
  response = http.get(url.request_uri)
  body = JSON.parse(response.body)
  puts "-> Código: #{response.code} - Cuerpo: #{body}"
  if response.code != '200'
    status 500
    { error: 'Error al obtener el clima', info: body.dig('error','info') }.to_json
  else
    body.to_json
  end
end
