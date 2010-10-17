require 'test_helper'

class ArtistsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:artists)
  end

  test "should show artist" do
    bob_dylan = artists(:bob_dylan)
    get :show, :id => bob_dylan.to_param
    assert_response :success
    assert assigns(:artist) == bob_dylan
  end
end

