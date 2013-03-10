class UserMailer < ActionMailer::Base
  
  helper YmCore::UrlHelper
  
  default :from => "info@tourbook.org.uk", 
          :bcc => ["developers@yoomee.com", "andy@yoomee.com"]
  
  def welcome_email(user)
    @user = user
    mail(:to => user.email, :subject => "Welcome to #{Settings.site_name}")
  end
  
  def new_admin(user)
    @user = user
    mail(:to => user.email, :subject => "#{Settings.site_name}: Your are now an administrator")
  end
  
end