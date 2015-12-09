RANDOM_CITIES = ['Paris','New-York','Bei-Jin', 'Moscov', 'Kiev', 'Roma', 'Berlin', 'Bangkok', 'Seoul','Tokyo']

get '/' do
  @city = params[:city_name] ||= RANDOM_CITIES.sample
  reload(@city)
  erb :index, :locals => {results: @intro}
end

post '/' do
  @city = params[:city_name] || 'Paris'
  reload(@city)
  erb :'index'
end

private



def reload(city)
  api_key = ENV['SECRET2']
  api_result = RestClient.get 'http://api.openweathermap.org/data/2.5/weather?q=' + city + '&appid=' + api_key
    @jhash = JSON.parse(api_result)

    @name        = @jhash['name']
    @id          = @jhash['weather'][0]['id']
    @description = @jhash['weather'][0]['description']
    @base        = @jhash['base']
    @temp        = @jhash['main']['temp']
    @pressure    = @jhash['main']['pressure']
    @humidity    = @jhash['main']['humidity']
    @windspeed   = @jhash['wind']['speed']
    @winddeg     = @jhash['wind']['deg']
    @clouds      = @jhash['clouds']['all']
    @windspeed   = @jhash['wind']['speed']
    @country     = @jhash['sys']['country']
    @sunrise     = @jhash['sys']['sunrise']
    @sunset      = @jhash['sys']['sunset']
    @lon         = @jhash['coord']['lon']
    @lat         = @jhash['coord']['lat']

end