require 'test_helper'

class AthletesControllerTest < ActionController::TestCase
  setup do
    @athlete = athletes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:athletes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create athlete" do
    assert_difference('Athlete.count') do
      post :create, :athlete => @athlete.attributes
    end

    assert_redirected_to athlete_path(assigns(:athlete))
  end

  test "should show athlete" do
    get :show, :id => @athlete.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @athlete.to_param
    assert_response :success
  end

  test "should update athlete" do
    put :update, :id => @athlete.to_param, :athlete => @athlete.attributes
    assert_redirected_to athlete_path(assigns(:athlete))
  end

  test "should destroy athlete" do
    assert_difference('Athlete.count', -1) do
      delete :destroy, :id => @athlete.to_param
    end

    assert_redirected_to athletes_path
  end
end
