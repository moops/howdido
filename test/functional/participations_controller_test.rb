require 'test_helper'

class ParticipationsControllerTest < ActionController::TestCase
  setup do
    @participation = participations(:gary_in_stewart)
  end

  test "should get new" do
  #  get :new
  #  assert_response :success
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
