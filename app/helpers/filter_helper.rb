module FilterHelper

  def show_collection_filter_link(collection)
    active = params[:collection] == collection.to_s.parameterize

    param_options = {}.tap do |hash|
      hash[:collection] = collection.name.parameterize unless active
      hash[:month] = params[:month] if params[:month].present?
      hash[:region] = params[:region] if params[:region].present?
      hash[:sort] = params[:sort] if params[:sort].present?
      hash[:tags] = params[:tags] if params[:tags].present?
      hash[:type] = params[:type] if params[:type].present?
      hash[:year] = params[:year] if params[:year].present?
    end

    param_options.reverse_merge!({:month => Date.today.month, :year => Date.today.year}) if controller_name.diary?

    li_with_active(active, (link_to collection, controller_name.diary? ? diary_path(param_options) : shows_path(param_options), :class => "label collections"))
  end

  def show_region_filter_link(content_tag, region)
    active = params[:region] == region

    param_options = {}.tap do |hash|
      hash[:collection] = params[:collection] if params[:collection].present?
      hash[:month] = params[:month] if params[:month].present?
      hash[:region] = region unless active
      hash[:sort] = params[:sort] if params[:sort].present?
      hash[:tags] = params[:tags] if params[:tags].present?
      hash[:type] = params[:type] if params[:type].present?
      hash[:year] = params[:year] if params[:year].present?
    end
    
    param_options.reverse_merge!({:month => Date.today.month, :year => Date.today.year}) if controller_name.diary?

    content_tag_with_active(content_tag, active, (link_to "#{content_tag(:i, nil, :class => 'icon-map-marker')} #{region}".html_safe, controller_name.diary? ? diary_path(param_options) : shows_path(param_options), :class => 'label'))
  end

  def tag_link(label, param_options, classes, add_remove=false)
    
    if (param_options[:tour_id].present? || param_options[:organisation_id].present? || param_options[:venue_id].present?) && (param_options[:start_date].present? || param_options[:end_date].present?)
      param_options[:month] = param_options[:start_date].split("/")[1]
      param_options[:year] = param_options[:start_date].split("/")[2]
      param_options[:tour_id] = ""
      param_options[:organisation_id] = ""
      param_options[:venue_id] = ""
    end  
    if param_options[:month].blank? && controller_name.diary?
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