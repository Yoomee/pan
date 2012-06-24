module ReviewsHelper
  
  def rating_stars(rating)
    return "<i>N/A</i>".html_safe if rating == nil
    "".tap do |stars|
      (1..5).each do |i|
        stars << content_tag(:i, nil, :class => "icon-star#{'-empty' if i > rating}")
      end
    end.html_safe
  end
  
  def short_date(date)
    date.strftime("%d %B %Y")
  end
  
end