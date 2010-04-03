class Venue < ActiveRecord::Base
  validates_presence_of :name, :address1, :city, :state

  has_many :events
end
