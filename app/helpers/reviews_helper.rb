module ReviewsHelper

  def review_form_url
    if @review.new_record?
      @tour ? tour_reviews_path(@tour) : performer_reviews_path(@performer)
    else
      @tour ? tour_review_path(@tour,@review) : performer_review_path(@performer,@review)
    end
  end
  
  def rating_stars(rating)
    return "" if rating == nil
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