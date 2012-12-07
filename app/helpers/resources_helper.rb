module ResourcesHelper 
  
  def prepend_http(url)
    "http://" + url unless url.match(/^.*:\/\//)
  end
  
end