require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase
  setup do
    @user_session = user_sessions(:gary)
  end
  
  test "should log in" do
  #  @request.session[:return_to] = nil
  #  assert_difference('UserSession.count') do
  #    post :create, :user_session => @user_session.attributes
  #  end

  #  assert_redirected_to user_sessions_path(assigns(:participation))
  end

  test "should log out" do
  #  assert_difference('UserSession.count', -1) do
  #    delete :destroy, :id => @user_session.to_param
  #  end

  #  assert_redirected_to root_path, 'we went somewhere wierd'
  #  assert_nil @request.session[:user_session], 'user session is still in the session hash'
  end
end
