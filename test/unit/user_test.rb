require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "save without first name" do
    u = User.new(last_name: 'last', born_on: '2000-01-01', :email => 'test@example.com', password: 'test_password')
    assert !u.save, "saved the user without a first name"
    u.first_name= 'first'
    assert u.save, "failed to save the user with a first_name"
  end
  
  test "save without last name" do
    u = User.new(:first_name => 'first', born_on: '2000-01-01', :email => 'test@example.com', password: 'test_password')
    assert !u.save, "saved the user without a last name"
    u.last_name= 'last'
    assert u.save, "failed to save the user with a last_name"
  end
  
  test "save without born_on" do
    u = User.new(:first_name => 'first', last_name: 'last', :email => 'test@example.com', password: 'test_password')
    assert !u.save, "saved the user without a birth date"
    u.born_on= '2000-01-01'
    assert u.save, "failed to save the user with a birth date"
  end
  
  test "save without email" do
    u = User.new(:first_name => 'first', last_name: 'last', born_on: '2000-01-01', password: 'test_password')
    assert !u.save, "saved the user without an email"
    u.email= 'test@example.com'
    assert u.save, "failed to save the user with an email"
  end
  
  test "name" do
    u = User.new({:first_name => 'gary', last_name: 'duncan'})
    assert_equal 'gary duncan', u.name
  end
  
  test "authenticate" do
    u = User.authenticate('adam@raceweb.ca', 'adam_pass')
    assert_equal 'adam lawrence', u.name
    
    u = User.authenticate('adam@raceweb.ca', 'bad_password')
    assert_nil u, 'adam@raceweb.ca authenticated with a bad password'
  end
  
  test "age" do
    u = User.new(born_on: Date.today - 41.years)
    assert_equal 41, u.age, 'birthday today'
    u.born_on= u.born_on + 1.day
    assert_equal 40, u.age, 'birthday tomorrow'
    u.born_on= Date.today - 1.day
    assert_equal 0, u.age, 'born yesterday'
  end
  
  test "participations" do
    gary = users(:gary)
    p = gary.participations_by_race
    assert_equal 3, p.size
  end
  
  test "run summaries" do
    gary = users(:gary)
    s = gary.run_summaries
    assert_equal 2, s.size, 'gary is in 2 runs and 1 tri'
  end
end
