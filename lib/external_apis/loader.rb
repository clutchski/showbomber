#
# This module is used to merge model objects from external sources
# into the database.
#

class Loader < ActiveRecord::Base

  def self.load_venue(venue)
    transaction do
      venue = Venue.find_or_create_by_name_and_city_and_state(venue.attributes)
      venue.save!
    end
    venue
  end

  def self.load_events(events)
    transaction do 
      events.each do |event|
        event.venue = self.load_venue(event.venue)
        event.save!
      end
    end
  end

end
