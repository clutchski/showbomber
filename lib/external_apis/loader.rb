#
# This module is used to merge model objects from external sources
# into the database.
#

class Loader < ActiveRecord::Base

  def self.load_venue(venue)
    transaction do
      Venue.find_or_create_by_name(venue.attributes)
    end
    venue
  end

  def self.load_events(events)
    transaction do 
      events.each do |event|
        #FIXME: wtf?
        venue = event.venue
        venue.save!
        event.venue = venue
        event.save!
      end
    end
  end

end
