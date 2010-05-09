class Event < ActiveRecord::Base

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
    "$#{n}"
  end

  def price_range_in_words

    in_words = ''
    if min_cost.blank? and max_cost.blank?
      in_words = ''
    elsif min_cost.blank? or max_cost.blank?
      cost = min_cost.blank? ? max_cost : min_cost
      in_words = to_dollars(cost)
    elsif max_cost == 0 and min_cost == 0
      in_words = 'free'
    elsif max_cost == min_cost
      in_words = to_dollars(min_cost)
    else
      min_dollars = to_dollars(min_cost)
      max_dollars = to_dollars(max_cost)
      in_words = "#{min_dollars} - #{max_dollars}"
    end
    in_words
  end

end
