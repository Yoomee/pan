module DirectoryHelper

  def directory_item_class(directory_item)
    case directory_item.class.to_s
    when "Performer"
      "icon-group"
    when "Promoter"
      "icon-briefcase"
    when "Tour"
      "icon-star"
    when "Venue"
      "icon-home"
    when "User"
      "icon-user"
    end
  end
  
  def directory_item_extra(directory_item)
    case directory_item.class.to_s
    when "Performer"
      tours_html =[]
      directory_item.tours.where("end_on < ?", Date.today).each do |tour|
        tours_html << link_to_self(tour)
      end
      tours_html.join('<br>').html_safe
    when "Promoter"
      venues_html = []
      directory_item.venues.each do |venue|
        venues_html << link_to_self(venue)
      end
      venues_html.join('<br>').html_safe
    when "Tour"
      "#{link_to_self(directory_item.performer)}<br>#{directory_item.dates_string}".html_safe
    when "Venue"
      link_to "#{content_tag(:i, nil, :class => directory_item_class(directory_item.promoter))} #{directory_item.promoter}".html_safe, directory_item.promoter
    when "User"
      if directory_item.promoter
        link_to_self(directory_item.promoter)
      elsif directory_item.performer
        link_to_self(directory_item.performer)
      end
    end
  end

  def directory_item_link(directory_item)
    link_to directory_item do
     "#{content_tag(:i, nil, :class => directory_item_class(directory_item))} #{directory_item.name.strip}".html_safe
    end.html_safe
  end
  
  def directory_items
    case controller_name
    when 'performers' then @performers
    when 'promoters' then @promoters
    when 'users' then @users
    when 'venues' then @venues
    when 'directory' then @everything
    else []
    end
  end

  def directory_item_tag(tag, original_tags)
    
  param_tags = original_tags.dup
  active_tag = param_tags.delete(tag.name)
  param_tags << tag.name unless active_tag

  param_options = {}.tap do |hash|
    hash[:tags] = param_tags if param_tags.present?
    hash[:letter] = params[:letter] if params[:letter].present?
    hash[:q] = params[:q] if params[:q].present?
    hash[:region] = params[:region] if params[:region].present?
    hash[:type] = params[:type] if params[:type].present?
  end
  link_to(tag_label(tag, :active => active_tag), action_name.search? ? directory_search_path(param_options) : directory_path(param_options), :class => "tag")
  end
  
  def present_directory_letters
    case controller_name
    when 'performers' then Performer.present_directory_letters
    when 'promoters' then Promoter.present_directory_letters
    when 'users' then User.present_directory_letters
    when 'venues' then Venue.present_directory_letters
    when 'directory' then (Performer.present_directory_letters + Promoter.present_directory_letters + Tour.present_directory_letters + Venue.present_directory_letters + User.present_directory_letters).uniq
    else []
    end
  end
  
  def rating_stars(rating)
    return "<i>N/A</i>".html_safe if rating == nil
    "".tap do |stars|
      (1..5).each do |i|
        stars << content_tag(:i, nil, :class => "icon-star#{'-empty' if i > rating}")
      end
    end.html_safe
  end
  
  def region_filter_link(content_tag, region)
    link_path = action_name.search? ? directory_search_path : directory_path
    param_options = {}.tap do |hash|
      hash[:letter] = params[:letter] if params[:letter].present?
      hash[:q] = params[:q] if params[:q].present?
      hash[:tags] = params[:tags] if params[:tags].present?
      hash[:type] = params[:type] if params[:type].present?
    end
    param_options.merge!({:region => region})
    content_tag_with_active(content_tag, params[:region] == region, (link_to "#{content_tag(:i, nil, :class => 'icon-map-marker')} #{region}".html_safe, action_name.search? ? directory_search_path(param_options) : directory_path(param_options)))
  end
  
  def type_filter_link(type)
    link_path = action_name.search? ? directory_search_path : directory_path
    param_options = {}.tap do |hash|
      hash[:letter] = params[:letter] if params[:letter].present?
      hash[:q] = params[:q] if params[:q].present?
      hash[:region] = params[:region] if params[:region].present?
      hash[:tags] = params[:tags] if params[:tags].present?
    end
    case type
    when "show"
      param_options.merge!({:type => "tour"})
      li_with_active(params[:type] == "tour", (link_to "#{content_tag(:i, nil, :class => 'icon-star')}Show".html_safe, action_name.search? ? directory_search_path(param_options) : directory_path(param_options)))
    when "performer"
      param_options.merge!({:type => "performer"})
      li_with_active(params[:type] == "performer", (link_to "#{content_tag(:i, nil, :class => 'icon-group')}Performer".html_safe, action_name.search? ? directory_search_path(param_options) : directory_path(param_options)))
    when "promoter"
      param_options.merge!({:type => "promoter"})
      li_with_active(params[:type] == "promoter", (link_to "#{content_tag(:i, nil, :class => 'icon-briefcase')}Organisation".html_safe, action_name.search? ? directory_search_path(param_options) : directory_path(param_options)))
    when "venue"
      param_options.merge!({:type => "venue"})
      puts param_options
      li_with_active(params[:type] == "venue", (link_to "#{content_tag(:i, nil, :class => 'icon-home')}Venue".html_safe, action_name.search? ? directory_search_path(param_options) : directory_path(param_options)))
    when "user"
      param_options.merge!({:type => "user"})
      li_with_active(params[:type] == "user", (link_to "#{content_tag(:i, nil, :class => 'icon-user')}Person".html_safe, action_name.search? ? directory_search_path(param_options) : directory_path(param_options)))

    end
  end

end