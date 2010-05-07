ENV["RAILS_ENV"] = "test"

require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails/test_help'
require 'forgery'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all


  #
  # Test data creation methods
  #

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
    defaults = get_random_venue_params
    defaults.merge(params)
    Venue.new(defaults)
  end

  def create_venue(params={})
    venue = new_venue(params)
    venue.save
    venue
  end

end
