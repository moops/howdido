require 'test_helper'

class LookupsControllerTest < ActionController::TestCase
  setup do
    @lookup = lookups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lookups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create lookup" do
    assert_difference('Lookup.count') do
      post :create, :lookup => @lookup.attributes
    end

    assert_redirected_to lookup_path(assigns(:lookup))
  end

  test "should show lookup" do
    get :show, :id => @lookup.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @lookup.to_param
    assert_response :success
  end

  test "should update lookup" do
    put :update, :id => @lookup.to_param, :lookup => @lookup.attributes
    assert_redirected_to lookup_path(assigns(:lookup))
  end

  test "should destroy lookup" do
    assert_difference('Lookup.count', -1) do
      delete :destroy, :id => @lookup.to_param
    end

    assert_redirected_to lookups_path
  end
end
