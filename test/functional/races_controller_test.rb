require 'test_helper'

class RacesControllerTest < ActionController::TestCase
  setup do
    @race = races(:westwood)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:races)
  end

  test "should get new" do
    @request.session[:user_session] = sessions(:adam)
    get :new
    assert_response :success
  end
  
  test "should get edit" do
    @request.session[:user_session] = sessions(:adam)
    get :edit, :id => @race.to_param
    assert_response :success
    assert_not_nil assigns(:race)
  end
  
  test "should create race" do
    @request.session[:user_session] = sessions(:adam)
    assert_difference('Race.count') do
      attr = @race.attributes
      attr['distance'] = attr['distance'].to_s
      attr['name'] = 'new random name'
      post :create, :race => attr
    end

    assert_redirected_to race_path(assigns(:race))
  end

  test "should show race" do
    get :show, :id => @race.to_param
    assert_response :success
    assert_not_nil assigns(:race)
  end

  test "should update race" do
    @request.session[:user_session] = sessions(:adam)
    attr = @race.attributes
    attr['distance'] = attr['distance'].to_s
    put :update, :id => @race.to_param, :race => attr
    assert_redirected_to race_path(assigns(:race))
  end

  test "should destroy race" do
    @request.session[:user_session] = sessions(:adam)
    assert_difference('Race.count', -1) do
      delete :destroy, :id => @race.to_param
    end

    assert_redirected_to races_path
  end

  
end
