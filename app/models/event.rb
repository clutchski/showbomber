class Event < ActiveRecord::Base

  scope :by_venue, lambda { |venue|
    joins(:venue).where({"venues.id" => venue.id})
  }

  scope :by_artist, lambda { |artist|
    joins(:artists).where({"artists.id" => artist.id})
  }

  belongs_to :venue
  has_and_belongs_to_many :artists

  validates_presence_of     :venue_id, :start_date
  validates_numericality_of :min_cost, :allow_nil=>true
  validates_numericality_of :max_cost, :allow_nil=>true
  validate :validate_cost

  def validate_cost
    if !min_cost.blank? and !max_cost.blank? and max_cost < min_cost
      errors.add(:max_cost, "The maximum cost is lower than the minimum.")
    end
  end

  def to_dollars(n)
    return (n <= 0) ? 'free': "$#{n}"
  end


  def price_range_in_words
    in_words = ''
    if min_cost.blank? and max_cost.blank?
      in_words = ''
    elsif min_cost.blank? or max_cost.blank?
      cost = min_cost.blank? ? max_cost : min_cost
      in_words = to_dollars(cost)
    elsif max_cost == min_cost
      in_words = to_dollars(min_cost)
    else
      min_dollars = to_dollars(min_cost)
      max_dollars = to_dollars(max_cost)
      in_words = "#{min_dollars} - #{max_dollars}"
    end
    in_words
  end

  def self.get_upcoming_events(day_count = nil)
    query = Event.where('start_date > ?', DateTime.now.midnight)
    if day_count != nil:
      query = query.where('start_date < ?', day_count.days.from_now.midnight)
    end
    return query.includes([:venue, :artists]).all(:order => "start_date ASC")
  end
end
