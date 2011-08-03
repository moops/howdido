require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase
  setup do
    @user_session = user_sessions(:gary)
  end
  
  test "should log in" do
    @request.session[:return_to] = nil
    @request.session[:user_session] = nil
    post :create, {:email => 'adam@raceweb.ca', :password => 'adam_pass'}
    assert_redirected_to user_path(users(:adam).to_param)
    assert_not_nil session[:user_session]
    
    @request.session[:return_to] = nil
    @request.session[:user_session] = nil
    post :create, {:email => 'gary@raceweb.ca', :password => 'gary_pass'}, {:return_to => race_path(races(:westwood))}
    assert_redirected_to race_path(races(:westwood))
    assert_not_nil session[:user_session]
    
    @request.session[:return_to] = nil
    @request.session[:user_session] = nil
    post :create, {:email => 'adam@raceweb.ca', :password => 'bad_pass'}
    assert_equal 'who are you talking about?', flash[:notice]
  
  end

  test "should log out" do
  #  assert_difference('UserSession.count', -1) do
  #    delete :destroy, :id => @user_session.to_param
  #  end

  #  assert_redirected_to root_path, 'we went somewhere wierd'
  #  assert_nil @request.session[:user_session], 'user session is still in the session hash'
  end
end
