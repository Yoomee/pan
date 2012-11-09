module FilterHelper

  def tag_link(label, param_tags, start_date, end_date, classes, add_remove=false)
    
    label = label + "&nbsp;" + content_tag(:i, "", :class => "icon-remove") if add_remove
    if current_page?(shows_path)
      link_to(shows_path(:tags => param_tags, :start_date => start_date, :end_date => end_date), :class => classes) do
        content_tag :span, label.html_safe, :class => "label tag-label"
      end
    elsif current_page?(diary_path)
      link_to(diary_path(:tags => param_tags, :start_date => start_date, :end_date => end_date), :class => classes) do
        content_tag :span, label.html_safe, :class => "label tag-label"
      end
    end
        
  end
  
end