module HasReviews
  
  def self.included(base)
    base.has_many :reviews, :dependent => :destroy
    base.scope :order_by_ratings, base.joins(:reviews).order("AVG(reviews.overall_rating) DESC").group("#{base.table_name}.id")
  end
  
  def overall_rating
    reviews.average(:overall_rating)
  end
  
end