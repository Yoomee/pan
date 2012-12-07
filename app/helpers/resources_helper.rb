module ResourcesHelper 
  
  def prepend_http(url)
    if url.match(/^.*:\/\//)
      url
    else
      "http://" + url 
    end
  end
  
  def host_name(url)
    URI.parse(url).host
  end
  
end