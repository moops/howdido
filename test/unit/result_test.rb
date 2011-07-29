require 'test_helper'

class ResultTest < ActiveSupport::TestCase

  test "name" do
    r = Result.new({:first_name => 'gary', :last_name => 'duncan'})
    assert_equal 'gary duncan', r.name
  end
  
  test "guess gender" do
    r = Result.new
    assert_equal 10, r.guess_gender('M4049')
    assert_equal 11, r.guess_gender('F4049')
    assert_equal 12, r.guess_gender('4049')
  end
  
  test "guess age" do
    r = Result.new
    assert_equal 19, r.guess_age('M0119')
    assert_equal 60, r.guess_age('M6099')
    assert_equal 52, r.guess_age('M5054')
    assert_equal 55, r.guess_age('F5059')
    assert_equal 50, r.guess_age('M50+')
    assert_equal 19, r.guess_age('M-U20')
  end
  
  test "div_winner_other" do
    #dave harvey in westwood
    r = results(:results_109)
    assert_equal 'stefan jakobsen', r.div_winner.name
  end
  
  test "div_winner_self" do
    #stefan jakobsen in westwood
    r = results(:results_096)
    assert_equal 'stefan jakobsen', r.div_winner.name
  end
  
  test "grade" do
    #TODO implement
    #stefan jakobsen in westwood
    #r = results(:results_096)
    #assert_equal ???, r.grade
  end
  
  test "points" do
    #stefan jakobsen in westwood
    r = results(:results_096)
    #6595 seconds (1:49:55), half marathon, 557 points
    assert_equal 556.5, r.points
  end
  
  test "future time for same grade" do
    #TODO implement
    #r = results(:results_096)
    #assert_equal ???, r.future_time_for_same_grade
  end
  
  test "future grade with same time" do
    #TODO implement
    #r = results(:results_096)
    #assert_equal ???, r.future_grade_with_same_time
  end
  
end
