module ResourcesHelper 
  
  def prepend_http(url)
    if url.match(/^.*:\/\//)
      url
    else
      "http://" + url 
    end
  end
  
end