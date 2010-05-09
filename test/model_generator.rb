#
# This module generates model objects for use in testing.
#

require 'forgery'

module ModelGenerator

  # artist generators

  def get_random_artist_params
    { :name => "The #{Forgery::Name.full_name} Band" }
  end

  def new_artist(params={})
    create_params = get_random_artist_params.merge(params)
    Artist.new(create_params)
  end

  def create_artist(params={})
    artist = new_artist(params)
    artist.save
    artist
  end

  # venue generators

  def get_random_venue_params
    { :name        => "The #{Forgery::Name.company_name} Club",
      :address     => Forgery::Address.street_address,
      :city        => Forgery::Address.city,
      :state       => Forgery::Address.state,
      :postal_code => Forgery::Address.zip,
      :phone       => Forgery::Address.phone
    }
  end

  def new_venue(params={})
    params = get_random_venue_params.merge(params)
    Venue.new(params)
  end

  def create_venue(params={})
    venue = new_venue(params)
    venue.save
    venue
  end


end
