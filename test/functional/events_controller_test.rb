require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  test "Non-existant events throw 404" do
    id = 9999999
    assert !Event.exists?(id)
    get :show, {:id => id}
    assert_response :missing
  end

  test "Show event page works" do
    event = Factory.create(:event)
    assert Event.exists?(event.id)
    get :show, {:id => event.id}
    assert_response :success
  end
end


