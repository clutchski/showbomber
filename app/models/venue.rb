class Venue < ActiveRecord::Base
  validates_presence_of :name, :address, :city, :state

  has_many :events
end
