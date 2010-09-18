#
# This module generates model objects for use in testing.
#

require 'forgery'

module ModelGenerator

  module ModelGenerator
    def generate(static_attributes={})
      attributes = get_random_attributes.merge(static_attributes)
      @model_class.new(attributes)
    end

    def persisted(static_attributes={})
      model_object = generate(static_attributes)
      model_object.save
      model_object
    end
  end


  class ArtistGenerator
    extend ModelGenerator

    @model_class = Artist

    def self.get_random_attributes
      { :name => "The #{Forgery::Name.full_name} Band" }
    end
  end


  class VenueGenerator
    extend ModelGenerator

    @model_class = Venue

    def self.get_random_attributes
      { :name        => "The #{Forgery::Name.company_name} Club",
        :address     => Forgery::Address.street_address,
        :city        => Forgery::Address.city,
        :state       => Forgery::Address.state,
        :postal_code => Forgery::Address.zip,
        :phone       => Forgery::Address.phone
      }
    end
  end

  class EventGenerator
    extend ModelGenerator

    @model_class = Event

    def self.get_random_attributes
      num_artists = rand(4) + 1
      num_days_in_future = rand(10) + 1

      { :venue => VenueGenerator.persisted,
        :artists => num_artists.times.collect{|n| ArtistGenerator.persisted},
        :start_date => num_days_in_future.days.from_now
      }
    end
  end

end
