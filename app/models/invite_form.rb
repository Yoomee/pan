module InviteForm
  
  include YmEnquiries::EnquiryForm
  
  title "Request an invite"
  
  intro "If you would like to know more about joining the Tourbook community tell us about your interest in promoting or performing and we will get in touch with more information."
  
  fields :name, :telephone, :email, :message
  
  validates :name,:presence => {:message => "Please tell us your name."}
  validates :message, :presence => {:message => "Please tell us more"}
  validates :email, :email => true, :allow_blank => false
  
  email_from Settings.site_email
  email_subject "Requesting an invite for #{Settings.site_name}"
  email_to "tourbook@thetouringnetwork.com"
  
  
  response_message "Thanks for your interest - we'll get back to you soon."
  
end
  
