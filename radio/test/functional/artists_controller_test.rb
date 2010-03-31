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
      post :create, :artist => artists(:one).attributes
    end
    assert_redirected_to artist_path(assigns(:artist))
  end

  test "shouldn't create artist" do
    assert_no_difference('Artist.count') do
      post :create, :artist => {'name'=>''}
    end
  end

  test "should show artist" do
    get :show, :id => artists(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => artists(:one).to_param
    assert_response :success
  end

  test "should update artist" do
    put :update, :id => artists(:one).to_param, :artist => artists(:one).attributes
    assert_redirected_to artist_path(assigns(:artist))
  end

  test "should destroy artist" do
    assert_difference('Artist.count', -1) do
      delete :destroy, :id => artists(:one).to_param
    end

    assert_redirected_to artists_path
  end
end
