module ShowsHelper
  
  def view_preference
    if %w{list block}.include?(session[:view])
      session[:view]
    else
      session[:view] = 'block'
    end
  end
  
end