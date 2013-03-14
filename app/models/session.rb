class Session < ActiveRecord::Base
  
  attr_accessible :user_id, :login_at, :logout_at, :count

  belongs_to :user
    
end
