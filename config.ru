# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
run Radio::Application

Sass::Plugin.options[:template_location] = 'app/stylesheets'
if Rails.env.production?
   Sass::Plugin.options[:never_update] = true
end

