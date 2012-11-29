module DirectoryHelper

  def get_params
    {}.tap do |hash|
      hash[:collection] = params[:collection] if params[:collection].present?
      hash[:letter] = params[:letter] if params[:letter].present?
      hash[:q] = params[:q] if params[:q].present?
      hash[:region] = params[:region] if params[:region].present?
      hash[:tags] = params[:tags] if params[:tags].present?
      hash[:type] = params[:type] if params[:type].present?
    end
  end

  def clear_all_filters_link
    param_options = get_params
    param_options.delete(:letter)
      if param_options.present?
        link_to("View all", action_name.search? ? directory_search_path(:letter => "0") : directory_path(:letter => "0"), :class => "btn", :id => "clear-all-filters")
      else
        link_to("Viewing all", "#", :class => "btn", :id => "no-filters")
      end
  end

  def letter_link(letter)
    param_options = get_params
    param_options.merge!({:letter => letter})

    content_tag(:li, link_to(letter, directory_path(param_options)).html_safe, :class => "#{'active' if params[:letter] == letter}#{' disabled' unless present_directory_letters.include?(letter)}")
  end

  def number_link
    param_options = get_params
    param_options.merge!({:letter => "0"})

    content_tag(:li, link_to('#', directory_path(param_options)).html_safe, :class => "#{'active' if params[:letter] == "#"}#{' disabled' unless present_directory_letters.join('').match(/[^A-Z]/)}")
  end

  def all_link
    param_options = get_params
    param_options.merge!({:letter => "+"})

    link_to("All".html_safe, action_name.search? ? directory_search_path(param_options) : directory_path(param_options))
  end

  def a_z_link
    param_options = get_params
    param_options.merge!({:letter => present_directory_letters.first})

    link_to("A &ndash; Z".html_safe, action_name.search? ? directory_search_path(param_options) : directory_path(param_options))
  end

  def collection_filter_link(collection)
    param_options = {}.tap do |hash|
      hash[:letter] = params[:letter] if params[:letter].present?
      hash[:q] = params[:q] if params[:q].present?
      hash[:region] = params[:region] if params[:region].present?
      hash[:tags] = params[:tags] if params[:tags].present?
      hash[:type] = params[:type] if params[:type].present?
    end

    active = params[:collection] == collection.to_s.parameterize
    param_options.merge!({:collection => collection.to_s.parameterize}) unless active

    li_with_active(active, (link_to collection, action_name.search? ? directory_search_path(param_options) : directory_path(param_options)))
  end

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
    hash[:collection] = params[:collection] if params[:collection].present?
    hash[:letter] = params[:letter] if params[:letter].present?
    hash[:q] = params[:q] if params[:q].present?
    hash[:region] = params[:region] if params[:region].present?
    hash[:tags] = param_tags if param_tags.present?
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
    active = params[:region] == region

    param_options = {}.tap do |hash|
      hash[:collection] = params[:collection] if params[:collection].present?
      hash[:letter] = params[:letter] if params[:letter].present?
      hash[:q] = params[:q] if params[:q].present?
      hash[:tags] = params[:tags] if params[:tags].present?
      hash[:type] = params[:type] if params[:type].present?
      hash[:region] = region unless active
    end

    content_tag_with_active(content_tag, active, (link_to "#{content_tag(:i, nil, :class => 'icon-map-marker')} #{region}".html_safe, action_name.search? ? directory_search_path(param_options) : directory_path(param_options)))
  end
  
  def type_filter_link(type)
    param_options = {}.tap do |hash|
      hash[:collection] = params[:collection] if params[:collection].present?
      hash[:letter] = params[:letter] if params[:letter].present?
      hash[:q] = params[:q] if params[:q].present?
      hash[:region] = params[:region] if params[:region].present?
      hash[:tags] = params[:tags] if params[:tags].present?
    end
    case type
    when "show"
      active = params[:type] == "tour"
      param_options.merge!({:type => "tour"}) unless active
      li_with_active(active, (link_to "#{content_tag(:i, nil, :class => 'icon-star')}Show".html_safe, action_name.search? ? directory_search_path(param_options) : directory_path(param_options)))
    when "performer"
      active = params[:type] == "performer"
      param_options.merge!({:type => "performer"}) unless active
      li_with_active(active, (link_to "#{content_tag(:i, nil, :class => 'icon-group')}Performer".html_safe, action_name.search? ? directory_search_path(param_options) : directory_path(param_options)))
    when "promoter"
      active = params[:type] == "promoter"
      param_options.merge!({:type => "promoter"}) unless active
      li_with_active(active, (link_to "#{content_tag(:i, nil, :class => 'icon-briefcase')}Organisation".html_safe, action_name.search? ? directory_search_path(param_options) : directory_path(param_options)))
    when "venue"
      active = params[:type] == "venue"
      param_options.merge!({:type => "venue"}) unless active
      puts param_options
      li_with_active(active, (link_to "#{content_tag(:i, nil, :class => 'icon-home')}Venue".html_safe, action_name.search? ? directory_search_path(param_options) : directory_path(param_options)))
    when "user"
      active = params[:type] == "user"
      param_options.merge!({:type => "user"}) unless active
      li_with_active(active, (link_to "#{content_tag(:i, nil, :class => 'icon-user')}Person".html_safe, action_name.search? ? directory_search_path(param_options) : directory_path(param_options)))
    end
  end

end