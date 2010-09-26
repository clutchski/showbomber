require 'test_helper'

class VenuesControllerTest < ActionController::TestCase

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:venues)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create venue" do
    assert_difference('Venue.count') do
      post :create, :venue => venues(:mercury_lounge).attributes
    end

    assert_redirected_to venue_path(assigns(:venue))
  end

  test "should show venue" do
    venue = venues(:bowery_ballroom)
    get :show, :id => venue.to_param

    assert_response :success
    actual_venue = assigns(:venue)
    assert_equal actual_venue, venue
  end

  test "should get edit" do
    get :edit, :id => venues(:mercury_lounge).to_param
    assert_response :success
  end

  test "should update venue" do
    put :update, :id => venues(:mercury_lounge).to_param, :venue => venues(:mercury_lounge).attributes
    assert_redirected_to venue_path(assigns(:venue))
  end

  test "should destroy venue" do
    assert_difference('Venue.count', -1) do
      delete :destroy, :id => venues(:mercury_lounge).to_param
    end

    assert_redirected_to venues_path
  end
end
