require 'aws-sdk'
require 'json'
require 'dotenv'

Dotenv.load

module TourSaver
  extend self
  def persist_tour_data(past_and_upcoming)
    s3 = Aws::S3::Client.new
    resp = s3.put_object(
      :bucket => "appmetheny.com",
      :key => "data/upcoming.json",
      :body => JSON.generate(past_and_upcoming[1])
    )
    resp = s3.put_object(
      :bucket => "appmetheny.com",
      :key => "data/past.json",
      :body => JSON.generate(past_and_upcoming[0].last(15))
    )


  end
end
