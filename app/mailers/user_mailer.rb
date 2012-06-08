class UserMailer < ActionMailer::Base
  
  helper YmCore::UrlHelper
  
  default :from => "site@pan.yoomee.com"
  
  def welcome_email(user)
    @user = user
    mail(:to => user.email, :subject => "Welcome to #{Settings.site_name}")
  end
  
end