class ApplicationController < ActionController::Base
  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  # helper_method :current_user, :admin?
  helper_method :admin?

  after_action :store_last_good_page

  protected

  def user_not_authorized
    flash[:alert] = 'You are not authorized to perform this action.'
    redirect_to request.referer || root_path
  end

  def store_last_good_page
    session[:last_good_page] = request.fullpath
    flash[:notice] = "last good page: #{session[:last_good_page]}"
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :born_on, :gender])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :born_on, :gender])
  end

  def admin?
    current_user && current_user.admin?
  end
end
