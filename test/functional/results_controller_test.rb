require 'test_helper'

class ResultsControllerTest < ActionController::TestCase
  setup do
    # shane r. winner of tzouhalem
    @result = results(:results_010)
  end

  test "should show result" do
    get :show, :id => @result.to_param
    assert_response :success
    assert_not_nil assigns(:result)
    assert_equal 'shane', assigns(:result).first_name
  end

  
end
