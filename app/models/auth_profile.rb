class AuthProfile
  
  attr_accessor :user_id, :name, :authority, :born_on

  def initialize(user_id, name, authority, born_on)
    @user_id = user_id
    @name = name
    @authority = authority
    @born_on = born_on
  end
end