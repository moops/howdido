require 'test_helper'

class ParticipationsControllerTest < ActionController::TestCase
  setup do
    @participation = participations(:gary_in_stewart)
  end

  test "should get new" do
    xhr :get, :new, {:result => results(:results_010).to_param, :user => users(:adam).to_param}
    #assert_response :success, 'not successfull'
    #assert_not_nil assigns(:participation_types), '@participation_types not assigned'
    #assert_equal 4, assigns(:participation_types).size, 'list of participation_types is wrong size'
    assert_not_nil assigns(:participation), '@participation not assigned'
    assert_not_nil assigns(:participation).user, '@participation.user not assigned'
    #assert_equal 'adam', assigns(:participation).user.first_name, 'adam is not the user'
    assert_not_nil assigns(:participation).result, '@participation.result not assigned'
    #assert_equal 'shane', assigns(:participation).result.first_name, 'shane is not the result'
  end

  test "should create participation" do
  #  assert_difference('Participation.count') do
  #    post :create, :participation => @participation.attributes
  #  end

  #  assert_redirected_to participation_path(assigns(:participation))
  end

  test "should destroy participation" do
  #  assert_difference('Participation.count', -1) do
  #    delete :destroy, :id => @participation.to_param
  #  end

  #  assert_redirected_to participations_path
  end
end
