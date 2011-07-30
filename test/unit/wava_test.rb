require 'test_helper'

class WavaTest < ActiveSupport::TestCase
  test "find for standard distance" do
    #age 33, gender 11, distance 10km, factor 1795
    w = Wava.find_for(33, 11, 10)
    assert_equal 1795, w.factor
  end
  
  test "find for non standard distance" do
    #age: 75, gender: 11, distance: 11km, factor: (3331 + 2756.4) / 2 = 3043.7
    w = Wava.find_for(75, 11, 11)
    assert_equal 3043.7, w.factor
    
    #age: 75, gender: 11, distance: 11.5km, 
    #formula: lower.factor + ((distance - lower.distance) / (upper.distance - lower.distance) * (upper.factor - lower.factor))
    #factor: 2756.4 + ((11.5 - 10) / (12 - 10) * (3331 - 2756.4)) = 3187.35
    w = Wava.find_for(75, 11, 11.5)
    assert_equal 3187.35, w.factor
  end
  
  test "list for distance" do
    #there should be 136 enteries for every distance
    #68 male and 68 female (age 8-75)
    w = Wava.list_for(10)
    assert_equal 136, w.size
    
    w = Wava.list_for(42.2)
    assert_equal 136, w.size
    
    #within 0.2 margin of error
    w = Wava.list_for(42.4)
    assert_equal 136, w.size
    
    #outside 0.2 margin of error
    w = Wava.list_for(42.5)
    assert_equal 0, w.size
  end
end
