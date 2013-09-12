module PromoterForm
  
  include YmEnquiries::EnquiryForm
  
  title "Application to join #{Settings.site_name}"
  intro "I'm afraid you can't join #{Settings.site_name} until your organisation has been added to the site. Please complete the form below and somebody will get in touch with you soon."
  fields :first_name, :last_name, :promoter_name, :promoter_region, :email, :phone, :message
  
  validates :first_name, :last_name, :promoter_name, :promoter_region, :email, :phone, :presence => true
  validates :email, :email => true, :allow_blank => true
  
  email_from Settings.site_email
  email_subject "New application to join #{Settings.site_name}"
  email_to "tourbook@thetouringnetwork.com"

  response_message "Thank you for submitting your application. We will get in touch with you soon."
  
end
  
