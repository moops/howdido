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
  
  test "distance description" do
    r = Race.new({:distance => 42.1, :distance_unit => 'km'})
    assert_equal 'marathon', r.distance_description, '42.1 is close enough to be a marathon'
    
    r = Race.new({:distance => 42.3, :distance_unit => 'km'})
    assert_equal 'marathon', r.distance_description, '42.3 is close enough to be a marathon'
    
    r = Race.new({:distance => 26.2, :distance_unit => 'mi'})
    assert_equal 'marathon', r.distance_description, '26 is close enough to be a marathon'
    
    r = Race.new({:distance => 42, :distance_unit => 'km'})
    assert_equal '42.0 km', r.distance_description, '42 is not close enough to be a marathon'
    
    r = Race.new({:distance => 26, :distance_unit => 'mi'})
    assert_equal '26.0 mi', r.distance_description, '26 is close enough to be a marathon'
    
    r = Race.new({:distance => 21, :distance_unit => 'km'})
    assert_equal 'half marathon', r.distance_description, '21 is close enough to be a half marathon'
    
    r = Race.new({:distance => 21.2, :distance_unit => 'km'})
    assert_equal 'half marathon', r.distance_description, '21.2 is close enough to be a half marathon'
    
    r = Race.new({:distance => 13.1, :distance_unit => 'mi'})
    assert_equal 'half marathon', r.distance_description, '13.1 is close enough to be a half marathon'
    
    r = Race.new({:distance => 20.9, :distance_unit => 'km'})
    assert_equal '20.9 km', r.distance_description, '20.9 is not close enough to be a half marathon'
    
    r = Race.new({:distance => 13, :distance_unit => 'mi'})
    assert_equal '13.0 mi', r.distance_description, '13 is not close enough to be a half marathon'
  end
  
end
