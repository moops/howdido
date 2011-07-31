require 'test_helper'

class RaceTest < ActiveSupport::TestCase
  
  test "save without name" do
    r = Race.new(:race_on => '2010-02-02')
    assert !r.save, "saved the race without a name"
    r.name= 'test name'
    assert r.save, "failed to save the race with a name"
  end
  
  test "save without date" do
    r = Race.new(:name => 'test name')
    assert !r.save, "saved the race without a date"
    r.race_on= '2010-02-02'
    assert r.save, "failed to save the race with a date"
  end

  test "finisher count" do
    assert_equal 85, races(:tzouhalem).finisher_count
  end
  
  test "display name" do
    assert_equal '2011 Gutbuster Trail Run 001', races(:tzouhalem).display_name
  end
  
  test "distance in km" do
    assert_equal 21.08, races(:westwood).distance_in_km
  end
  
  test "female winner" do
    assert_equal 'claire morgan', races(:westwood).gender_winner(11).name
  end
  
  test "male winner" do
    assert_equal 'shawn nelson', races(:westwood).gender_winner(10).name
  end
  
  test "division winner" do
    assert_equal 'carey sather', races(:westwood).winner('F4049',11).name
  end
  
end
