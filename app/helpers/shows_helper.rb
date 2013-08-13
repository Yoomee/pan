module ShowsHelper
  
  def facebook_twitter_youtube_link
    case link.host
    when "facebook.com"
      link_to link.url, :target => '_blank' do
        content_tag(:i, "", :class => "icon-facebook")
      end
    when "twitter.com" 
      link_to link.url, :target => '_blank' do
        content_tag(:i, "", :class => "icon-twitter")
      end
    when "youtube.com"
      link_to link.url, :target => '_blank' do
        content_tag(:i, "", :class => "icon-youtube")
      end
    end
  end
    
  def view_preference
    if %w{list block}.include?(session[:view])
      session[:view]
    else
      session[:view] = 'block'
    end
  end
  
end