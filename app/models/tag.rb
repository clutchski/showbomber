class Tag < ActiveRecord::Base

  has_and_belongs_to_many :artists

  def name=(name)
    self[:name] = name.downcase if name
  end

end
