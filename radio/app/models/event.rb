class Event < ActiveRecord::Base
  belongs_to :venue
  has_and_belongs_to_many :artists

  validates_presence_of :venue_id, :start_date
end
