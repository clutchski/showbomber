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

end
