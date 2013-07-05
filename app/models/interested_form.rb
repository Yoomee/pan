module InterestedForm
  
  include YmEnquiries::EnquiryForm
  
  title ""
  
  intro ""
  
  fields :dates_interested_in, :message
  
  email_from Settings.site_email
  email_subject "Someone's expressed interest in a show - #{Settings.site_name}"
  email_to "panpromoters@gmail.com"
  
  
  response_message "Thanks for your interest - we'll get back to you soon."  
end
  
