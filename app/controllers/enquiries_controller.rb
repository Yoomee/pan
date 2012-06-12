class EnquiriesController < ApplicationController
  
  include YmEnquiries::EnquiriesController
  load_and_authorize_resource
  
  def new
    if params[:id].nil?
      render_404
    else
      begin
        attrs = {:form_name => params[:id].to_s}
        if attrs[:form_name] == "promoter"
          attrs.merge!((session[:user_params] || {}).slice("first_name", "last_name", "email"))
        end
        @enquiry = Enquiry.new(attrs)
      rescue NameError
        render_404
      end
    end
  end
  
end