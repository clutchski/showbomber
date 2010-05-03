#
# This module contains test for the live nation api.
#

# stdlib
require 'test_helper'

# project
require 'lib/external_apis/live_nation.rb'

class LiveNationTest < ActionController::IntegrationTest

  test "test extractor works" do
    xml_data = LiveNationAPI::Extractor.extract(test_mode=true)
    assert xml_data.is_a? Hash
    assert xml_data.has_key? 'result'
    events = xml_data['result']
    assert events.has_key? 'event'
    assert events['event'].is_a? Array
  end

end
