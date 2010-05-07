#
# This module is used to merge model objects from external sources
# into the database.
#

class Loader < ActiveRecord::Base

  def self.load_venue(venue)
    transaction do
      venue.save
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
