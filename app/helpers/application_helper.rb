module ApplicationHelper
  
  def description_tag(title, content)
    if %w{yes no}.include?(content.to_s.downcase)
      content = content_tag(:span, content, :class => "label #{content.to_s.downcase=='yes' ? 'label-success' : 'label-important'}")
    end
    content_tag(:dt, title) + content_tag(:dd, content)
  end
  
end
