module DirectoryHelper

  def directory_items
    case controller_name
    when 'performers' then @performers
    when 'promoters' then @promoters
    when 'users' then @users
    when 'venues' then @venues
    else []
    end
  end
  
  def present_directory_letters
    case controller_name
    when 'performers' then Performer.present_directory_letters
    when 'promoters' then Promoter.present_directory_letters
    when 'users' then User.present_directory_letters
    when 'venues' then Venue.present_directory_letters
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

end