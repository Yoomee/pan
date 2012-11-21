module DirectoryHelper

  def directory_item_class(directory_item)
    case directory_item.class.to_s
    when "Performer"
      "icon-user"
    when "Promoter"
      "icon-group"
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
      directory_item.region
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
  
  def directory_item_tags(directory_item)
    case 
    when directory_item.try(:genres)
      render "tags/horizontal_list", :tags => directory_item.genres
    when directory_item.class.to_s == "Venue"
      link_to "#{content_tag(:i, nil, :class => "icon-map-marker")} #{directory_item}".html_safe, directory_item
    end
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
  
  def type_filter_link(type)
    link_path = action_name.search? ? directory_search_path : directory_path
    param_options = {}.tap do |hash|
      hash[:letter] = params[:letter] if params[:letter].present?
      hash[:q] = params[:q] if params[:q].present?
    end
    case type
    when "show"
      param_options.merge!({:type => "tour"})
      li_with_active(params[:type] == "tour", (link_to "Show", action_name.search? ? directory_search_path(param_options) : directory_path(param_options)))
    when "performer"
      param_options.merge!({:type => "performer"})
      li_with_active(params[:type] == "performer", (link_to "Performer", action_name.search? ? directory_search_path(param_options) : directory_path(param_options)))
    when "promoter"
      param_options.merge!({:type => "promoter"})
      li_with_active(params[:type] == "promoter", (link_to "Organisation", action_name.search? ? directory_search_path(param_options) : directory_path(param_options)))
    when "venue"
      param_options.merge!({:type => "venue"})
      puts param_options
      li_with_active(params[:type] == "venue", (link_to "Venue", action_name.search? ? directory_search_path(param_options) : directory_path(param_options)))
    when "user"
      param_options.merge!({:type => "user"})
      li_with_active(params[:type] == "user", (link_to "Person", action_name.search? ? directory_search_path(param_options) : directory_path(param_options)))

    end
  end

end