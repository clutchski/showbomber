require 'test_helper'

class VenuesControllerTest < ActionController::TestCase

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:venues)
  end

  test "should show venue" do
    venue = venues(:bowery_ballroom)
    get :show, :id => venue.to_param

    assert_response :success
    actual_venue = assigns(:venue)
    assert_equal actual_venue, venue
  end
end
