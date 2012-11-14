module FilterHelper

  def tag_link(label, param_options, classes, add_remove=false)
    
    if param_options[:month].blank?
      param_options[:month] = Date.today.month
      param_options[:year] = Date.today.year
    end

    label.gsub!(/-/, ' ')
    label = label + "&nbsp;" + content_tag(:i, "", :class => "icon-remove") if add_remove
    
    if current_page?(shows_path)
      link_to(shows_path(param_options), :class => classes) do
        content_tag :span, label.html_safe, :class => "label tag-label"
      end
    elsif current_page?(diary_path)
      link_to(diary_path(param_options), :class => classes) do
        content_tag :span, label.html_safe, :class => "label tag-label"
      end
    end
        
  end
  
end