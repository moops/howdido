require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:gary)
  end

  test "should get new" do
    xhr :get, :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      attr = @user.attributes
      attr['email'] = 'gary_2@raceweb.ca'
      attr['password'] = 'password'
      attr['password_confirmation'] = 'password'
      post :create, :user => attr
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test "should show user" do
    @request.session[:user_session] = user_sessions(:gary)
    get :show, :id => @user.to_param
    assert_response :success
    
    #gary is logged in and trying to view adam's show page
    get :show, :id => users(:adam).to_param
    assert_response :success
    #make sure he was directed to his own page
    assert_equal 'gary duncan', assigns(:user).name
    
    #a user with no participations should be redirected to the root url
    #TODO - not working
    #@request.session[:user_session] = user_sessions(:adam)
    #get :show, :id => users(:adam).to_param
    #assert_redirected_to root_url
  end

end
