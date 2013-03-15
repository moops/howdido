class UsersController < ApplicationController

  load_and_authorize_resource

  # GET /users/1
  def show
    @user = current_user
    @run_summaries = @user.run_summaries
    redirect_to :root, notice: 'you have no participations' unless @user.participations.any?
  end

  # GET /users/new
  def new
    @genders = Lookup.list_for('gender')
  end

  # GET /users/1/edit
  def edit
    @genders = Lookup.list_for('gender')
  end

  # POST /users
  def create
    @user.roles=(['athlete'])
    if @user.save
      # sign in
      @user.session= Session.create(user_id: @user.id, login_at: Time.now, logout_at: nil, count: 1)
      session[:user_session] = @user.session.id
      redirect_to @user
    else
      msg = ''
      if @user.errors.any?  
        @user.errors.full_messages.each do |m|
          msg = msg << m
        end
      end
      redirect_to :root, notice: 'user creation failed because: ' << msg
    end
  end
end