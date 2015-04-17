require './lib/app_metheny/tour_fetcher'
require './lib/app_metheny/tour_saver'
require 'dotenv'
require 'pp'
Dotenv.load

module AppMetheny
  extend self

  def fetch_tour_data()
    tour_data = TourFetcher.get_tour_data
    TourSaver.persist_tour_data tour_data
  end
end
