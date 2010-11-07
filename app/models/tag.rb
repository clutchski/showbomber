class Tag < ActiveRecord::Base

  def name=(name)
    self[:name] = name.downcase if name
  end

end
