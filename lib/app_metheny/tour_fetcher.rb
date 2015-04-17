require 'net/http'
require 'json'
require 'time'
require 'pp'
require 'timezone'
require 'dotenv'
Dotenv.load

module TourFetcher
  extend self
  def get_tour_data()
    # Make requests for each of these at some point:
    # pat_metheny_associated_acts = ["PatMetheny","PatMethenyGroup","PatMethenyTrio"]

    uri = URI('http://api.bandsintown.com/artists/%s/events' % "PatMetheny")

    params = {
      "format" =>  'json',
      "app_id" =>  ENV.fetch('bandsintown_app_id'),
      "date" => "2012-01-01,2020-01-01",
      "api_version" => "2.0"
    }

    uri.query = URI.encode_www_form(params)
    response = Net::HTTP.get_response(uri)

    if response.kind_of? Net::HTTPSuccess

      Timezone::Configure.begin do |c|
        c.username = ENV.fetch('geonames_username')
      end




      json = JSON.parse(response.body)



      all_stops = json.map{|stop|
        latitude = stop["venue"]["latitude"]
        longitude = stop["venue"]["longitude"]
        timezone = Timezone::Zone.new :latlon => [ latitude, longitude]

        local_date_time_utc = timezone.local_to_utc(Time.parse(stop["datetime"] + " UTC"))

        {
          "latitude" => latitude,
          "longitude" => longitude,
          "datetime" => local_date_time_utc,
          "venueName" => stop["venue"]["name"],
          "venuePlace" => stop["venue"]["city"] + ", " +  stop["venue"]["country"]
        }
      }

      all_stops.partition { |stop|
        pp stop
        stop["datetime"] < Time.now.utc
      }

    else
      raise 'bandsintown api request failed'
    end
  end
end
