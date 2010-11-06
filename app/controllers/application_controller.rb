class ApplicationController < ActionController::Base
  layout "main"
  protect_from_forgery

  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  private

  def record_not_found
    render :text => "Uh oh. This page doesn't exist.", :status => 404
  end
end
