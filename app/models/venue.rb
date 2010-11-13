class Venue < ActiveRecord::Base
  has_many :events

  def to_param
    "#{id}-#{name.downcase.gsub(/[^a-z0-9']+/i, '-')}"
  end
end
