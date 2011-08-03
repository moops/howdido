require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase
  
  test "should log in and go to user path" do
    post :create, {:email => 'adam@raceweb.ca', :password => 'adam_pass'}
    assert_redirected_to user_path(users(:adam).to_param)
    assert_not_nil session[:user_session]
  end
    
  test "should log in and go to westwood path" do
    post :create, {:email => 'gary@raceweb.ca', :password => 'gary_pass'}, {:last_good_page => race_path(races(:westwood))}
    assert_redirected_to race_path(races(:westwood))
    assert_not_nil session[:user_session]
  end
    
  test "should not log in with bad password" do
    post :create, {:email => 'adam@raceweb.ca', :password => 'bad_pass'}
    assert_equal 'who are you talking about?', flash[:notice]
    assert_nil session[:user_session]
  end

  test "should log out" do
    delete :destroy, :id => @user_session.to_param, {:user_session => user_sessions(:gary).to_param}
    assert_redirected_to root_path, 'we went somewhere wierd'
  #  assert_nil @request.session[:user_session], 'user session is still in the session hash'
  end
end
