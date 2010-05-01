require 'test_helper'

class ArtistsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:artists)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create artist" do
    assert_difference('Artist.count') do
      post :create, :artist => artists(:bob_dylan).attributes
    end
    assert_redirected_to artist_path(assigns(:artist))
  end

  test "shouldn't create artist" do
    assert_no_difference('Artist.count') do
      post :create, :artist => {'name'=>''}
    end
  end

  test "should show artist" do
    bob_dylan = artists(:bob_dylan)
    get :show, :id => bob_dylan.to_param
    assert_response :success
    assert assigns(:artist) == bob_dylan
  end

  test "should get edit" do
    get :edit, :id => artists(:bob_dylan).to_param
    assert_response :success
  end

  test "should update artist" do
    id = artists(:bob_dylan).to_param
    params = artists(:bob_dylan).attributes
    put :update, :id => id, :artist => params
    assert_redirected_to artist_path(assigns(:artist))
  end

  test "should destroy artist" do
    assert_difference('Artist.count', -1) do
      delete :destroy, :id => artists(:bob_dylan).to_param
    end

    assert_redirected_to artists_path
  end

  test "should get artist's songs" do
    get :songs, :id => artists(:neil_young).to_param
    assert_response :success
  end

end

