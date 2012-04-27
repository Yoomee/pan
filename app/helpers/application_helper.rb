module ApplicationHelper
  
  def description_tag(title, content)
    content_tag(:dt, title) + content_tag(:dd, content)
  end
  
end
