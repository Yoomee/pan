module FilterHelper

  def tag_link(label, param_options, classes, add_remove=false)
    
    if (param_options[:tour_id].present? || param_options[:organisation_id].present? || param_options[:venue_id].present?) && (param_options[:start_date].present? || param_options[:end_date].present?)
      param_options[:month] = param_options[:start_date].split("/")[1]
      param_options[:year] = param_options[:start_date].split("/")[2]
      param_options[:tour_id] = ""
      param_options[:organisation_id] = ""
      param_options[:venue_id] = ""
    end  
    if param_options[:month].blank?
      param_options[:month] = Date.today.month
      param_options[:year] = Date.today.year
    end
    
    param_options.delete_if {|k, v| v.blank?}

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