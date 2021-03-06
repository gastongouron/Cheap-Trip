DEVELOPER_KEY = ENV['SECRET1']
DEVELOPER_KEY2 = ENV['SECRET2']
YOUTUBE_API_SERVICE_NAME = 'youtube'
YOUTUBE_API_VERSION = 'v3'
RANDOM_CITIES = ['Paris','San Francisco','New York', 'Moscov', 'Kiev', 'Roma', 'Bangkok', 'Seoul','Tokyo','Riga' ,'Praha','Stockolm','Barcelona','Phnom Penh','Kingston']


# Routes
get '/' do
  @city = params[:city_name] ||= RANDOM_CITIES.sample
  main(@city)
  reload(@city)
  erb :index, :locals => {results: @intro}
end

post '/' do
  @city = params[:city_name]
  reload(@city)
  main(@city)
  erb :'index'
end

# OpenweatherMaps API call
#private

def reload(city)

  formated_city = city.delete(" ")
  api_key = ENV['SECRET2']
  api_result = RestClient.get 'http://api.openweathermap.org/data/2.5/weather?q=' + formated_city + '&appid=' + api_key
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
    @sunrise     = Time.at(@jhash['sys']['sunrise']).to_datetime.strftime("%H:%M:%S")
    @sunset      = Time.at(@jhash['sys']['sunset']).to_datetime.strftime("%H:%M:%S")
    @lon         = @jhash['coord']['lon']
    @lat         = @jhash['coord']['lat']
end



def get_service
  client = Google::APIClient.new(
    :key => DEVELOPER_KEY,
    :authorization => nil,
    :application_name => $PROGRAM_NAME,
    :application_version => '1.0.0')
  youtube = client.discovered_api(YOUTUBE_API_SERVICE_NAME, YOUTUBE_API_VERSION)
  return client, youtube
end

def main(city)

  opts = Trollop::options do
    opt :q, '', :type => String, :default => "#{city} dj set techno"
    opt :max_results, 'Max results', :type => :int, :default => 1 #<- amount of results
  end
  client, youtube = get_service

  begin

    search_response = client.execute!(
      :api_method => youtube.search.list,
      :parameters => {
        :part => 'snippet',
        :q => opts[:q],
        :maxResults => opts[:max_results]
      }
    )

    @yid = []
    @videos = []
    @channels = []
    @playlists = []

    search_response.data.items.each do |search_result|
      case search_result.id.kind
        when 'youtube#video'
          @videos << "#{search_result.snippet.title}"
          @yid << "#{search_result.id.videoId}"
        when 'youtube#channel'
          @channels << "#{search_result.snippet.title} (#{search_result.id.channelId})"
        when 'youtube#playlist'
          @playlists << "#{search_result.snippet.title} (#{search_result.id.playlistId})"
      end
    end

    @final_id = @yid.sample.to_s

    puts @final_id
    puts '------------------------'
    puts @videos
    puts @yid
    # puts "Videos:\n", videos, "\n"
    # puts "Channels:\n", channels, "\n"
    # puts "Playlists:\n", playlists, "\n"
    rescue Google::APIClient::TransmissionError => e
    puts e.result.body
  end
end