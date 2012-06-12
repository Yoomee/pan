class ApplicationController < ActionController::Base
  protect_from_forgery
  
  include YmUsers::ApplicationController
  
  before_filter :authenticate, :clear_registration_session!

  AUTH_USERS = { "pan" => "highlands123" }

  def after_sign_in_path_for(user)
    if user.promoter
      promoter_path(user.promoter)
    elsif user.performer
      performer_path(user.performer)
    else
      params.delete(:next) || super
    end
  end

  private
  def authenticate
    return true unless Rails.env.production?
    authenticate_or_request_with_http_basic do |username|
      AUTH_USERS[username]
    end
  end

  def clear_registration_session!
    unless %{registrations enquiries}.include?(controller_name)
      session[:user_params] = session[:user_step] = nil
    end
  end
  
end
