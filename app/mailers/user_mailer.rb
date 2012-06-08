class UserMailer < ActionMailer::Base
  
  default :from => "site@pan.yoomee.com"
  
  def welcome_email(user)
    @user = user
    mail(:to => user.email, :subject => "Welcome to PAN")
  end
  
end