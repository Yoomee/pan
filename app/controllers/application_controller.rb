class ApplicationController < ActionController::Base
  protect_from_forgery
  
  include YmUsers::ApplicationController
  
  before_filter :clear_registration_session!
  before_filter :check_for_suspension

  AUTH_USERS = { "pan" => "highlands123" }

  def after_sign_in_path_for(user)
    if user.promoter
      welcome_path
    elsif user.performer
      welcome_path
    else
      params.delete(:next) 
      welcome_path
    end
  end

  private
  def authenticate
    return true unless Rails.env.production?
    authenticate_or_request_with_http_basic do |username|
      AUTH_USERS[username]
    end
  end

  def check_for_suspension
    if current_user.try(:suspended?)
      redirect_to renew_path unless params[:action] == 'destroy' || params[:action] == 'renew' || (params[:controller] == 'pages' && params[:id] == Page.find_by_slug('contact').id.to_s)
    end
  end

  def clear_registration_session!
    unless %{registrations enquiries}.include?(controller_name)
      session[:user_params] = session[:user_step] = nil
    end
  end
  
end
