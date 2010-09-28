#
# This class serves "static" pages like, contact and help
#
class StaticController < ApplicationController

  def contact
    render "contact"
  end
end
