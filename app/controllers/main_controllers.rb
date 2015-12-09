DEVELOPER_KEY = ENV['SECRET1']
DEVELOPER_KEY2 = ENV['SECRET2']
YOUTUBE_API_SERVICE_NAME = 'youtube'
YOUTUBE_API_VERSION = 'v3'
RANDOM_CITIES = ['Paris','New-York','Bei-Jin', 'Moscov', 'Kiev', 'Roma', 'Berlin', 'Bangkok', 'Seoul','Tokyo','Rio','Praha','Stockolm','Barcelona','Phnom Penh','Kingston']


# Routes
get '/' do
  @n = 'BVBWQscPWZs'
  @city = params[:city_name] ||= RANDOM_CITIES.sample
  reload(@city)
  erb :index, :locals => {results: @intro}
end

post '/' do
  @n = 'BVBWQscPWZs'
  @city = params[:city_name] || 'Paris'
  reload(@city)
  erb :'index'
end

# Youtube API call
def get_service
  client = Google::APIClient.new(
    :key => DEVELOPER_KEY,
    :authorization => nil,
    :application_name => $PROGRAM_NAME,
    :application_version => '1.0.0')
  youtube = client.discovered_api(YOUTUBE_API_SERVICE_NAME, YOUTUBE_API_VERSION)
  return client, youtube
end

def main
  opts = Trollop::options do
    opt :q, '', :type => String, :default => 'San Francisco'
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
    id = []
    videos = []
    channels = []
    playlists = []

    search_response.data.items.each do |search_result|
      case search_result.id.kind
        when 'youtube#video'
          videos << "#{search_result.snippet.title}"
          id << "#{search_result.id.videoId}"
        when 'youtube#channel'
          channels << "#{search_result.snippet.title} (#{search_result.id.channelId})"
        when 'youtube#playlist'
          playlists << "#{search_result.snippet.title} (#{search_result.id.playlistId})"
      end
    end

    # @rez = videos
    # @rez.each do |codeline|
    #   codeline.split()
    # end

    @youtube_id = id
    @song = videos

    puts "Videos:\n", videos, "\n"
    puts "Channels:\n", channels, "\n"
    puts "Playlists:\n", playlists, "\n"
  rescue Google::APIClient::TransmissionError => e
    puts e.result.body
  end
end

main

# OpenweatherMaps API call
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

