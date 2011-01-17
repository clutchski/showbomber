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

  test "should get edit" do
    artist = Factory.create(:artist)
    get :edit, :id => artist.to_param
    assert_response :success
  end

  test "should update artist" do
    artist = Factory.create(:artist)
    put :update, :id => artist.to_param, :artist => artist.attributes
    assert_redirected_to artist_path(assigns(:artist))
  end

end

