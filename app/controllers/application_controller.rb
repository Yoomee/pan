class ApplicationController < ActionController::Base
  protect_from_forgery
  
  include YmUsers::ApplicationController
  
  before_filter :authenticate

  AUTH_USERS = { "pan" => "highlands123" }

  private
  def authenticate
    return true unless Rails.env.production?
    authenticate_or_request_with_http_basic do |username|
      AUTH_USERS[username]
    end
  end
  
  def flash_notice(resource, action)
    resource_class = resource.class.to_s.humanize.downcase
    flash[:notice] = case action
    when :destroy then "Deleted #{resource_class} - #{resource}"
    when :update then "Updated #{resource_class} - #{resource}"
    else "Created new #{resource_class} - #{resource}"
    end
  end
  
end
