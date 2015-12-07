require 'rubygems'
require 'bundler'
Bundler.setup
require 'sinatra'
require 'json'
require 'rest-client'

get '/' do
  @city = params[:city_name] ||= 'Paris'
  reload(@city)
  erb :index, :locals => {results: @intro}
end

post '/' do
  @city = params[:city_name]
  reload(@city)
  erb :index
end

private

@intro = nil

def reload(city)
  api_key = '501bc85a381f6c157ba0ae1458b4ae6d'
  api_result = RestClient.get 'http://api.openweathermap.org/data/2.5/weather?q=' + city + '&appid=' + api_key
  p @jhash = JSON.parse(api_result)

  @main = ''
  @name = @jhash['name']

  @jhash['main'].each do |w|
    title_tag = w[0]
    info_item = w[1]
    @main << "<tr><td>#{title_tag}</td><td>#{info_item}</td></tr>"
  end

  @jhash['sys'].each do |l|
    title = l[0]
    info = l[1]
    @main << "<tr><td>#{title}</td><td>#{info}</td></tr>"
  end

  #@main << @jhash['name']
  @jhash['coord'].each do |c|
    title = c[0]
    info = c[1]
  @main << "<tr><td>#{title}</td><td>#{info}</td></tr>"
  end

  @jhash['wind'].each do |s|
    title = s[0]
    info = s[1]
  @main << "<tr><td>#{title}</td><td>#{info}</td></tr>"
  end

  @jhash['weather'][0].each do |w|
    title = w[0]
    info = w[1]
    @main << "<tr><td>#{title}</td><td>#{info}</td></tr>"
  end

end


# {"coord"=> {"lon"=>2.35,
#             "lat"=>48.85},

#  "weather"=> [
#               {"id"=>800,
#                "main"=>"Clear",
#                "description"=>"Sky is Clear",
#                "icon"=>"01n"}
#                ],

#  "base"=>"cmc stations",

#  "main"=>{"temp"=>281.82,
#           "pressure"=>1028,
#           "humidity"=>87,
#           "temp_min"=>281.15,
#           "temp_max"=>282.15},

#   "wind"=>{ "speed"=>2.1,
#             "deg"=>200},

#   "clouds"=>{"all"=>0},

#   "dt"=>1449451800,

#   "sys"=>{"type"=>1,
#           "id"=>5615,
#           "message"=>0.0041,
#           "country"=>"FR",
#           "sunrise"=>1449473364,
#           "sunset"=>1449503658},
#   "id"=>2988507,
#   "name"=>"Paris",
#   "cod"=>200}