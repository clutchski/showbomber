#
# This module controls the interaction with the livenation.com API.
#
# http://developers.livenation.com/index.html
#

require 'httparty'


module LiveNationAPI

 class Extractor

    include HTTParty

    base_uri "http://developers.livenation.com"
    format :xml

    @@url="/index.php"
    @@args="/allEvents/auth/a4473318605a9b2b9c33afa0b3e246fa"

    def self.extract(test_mode=false)
      test_mode_code = test_mode ? '1' : '0'
      args = @@args + "/testMode/#{test_mode_code}"
      get(@@url, :query => {"t"=> args})
    end
  end

 
end
