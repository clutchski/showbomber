require 'hassle'  
 
class HassleRailtie < Rails::Railtie  
  config.middleware.use Hassle if Rails.env == 'production'   
end      
