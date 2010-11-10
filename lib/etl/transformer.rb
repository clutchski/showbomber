
module ETL

  # 
  # This class transforms the feed data into business objects.
  #
  class Transformer

    def self.transform_venue(venue_data)
      Venue.new do |v|
        v.name = venue_data[:name]
        v.address = venue_data[:address]
        v.city = venue_data[:city]
        v.state = venue_data[:state]
        v.phone = venue_data[:phone]
        #FIXME: add website
      end
    end

    def self.transform_event(event_data)
      venue = transform_venue(event_data[:venue])
      artists = event_data[:artists].collect{|name| Artist.new(:name=>name)}

      Event.new do |e|
        e.min_cost = event_data[:cost]
        e.start_date = event_data[:date]
        e.artists = artists
        e.venue = venue
      end
    end

    def self.transform(events_data)
      return events_data.collect{|e| self.transform_event(e)}
    end
  end
end
