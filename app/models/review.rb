class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :performer
  belongs_to :tour
  
  validates :title, :description, :overall_rating, :user, :performer, :presence => true
  
  default_scope order("created_at DESC")
end

Review::RATING_OPTIONS = [["Terrible", 1], ["Poor", 2], ["Average", 3], ["Very good", 4], ["Excellent", 5]]

Review::PERFORMER_RATINGS = [[:rural_rating, "Understanding for rural touring"], [:small_venue_rating, "Ability to produce for small, rural venues"], [:relationship_rating, "Relationship with promoter"], [:support_rating, "Over-all support to promoters"], [:value_rating, "Value for money"], [:marketing_rating, "Marketing materials"], [:workshop_rating, "Workshop delivery/appropriateness"]]

Review::TOUR_RATINGS = [[:rural_rating, "Appropriateness for rural touring"], [:get_in_rating, "Get-in"], [:after_show_rating, "Audience liaison/after-show"], [:workshop_rating, "Workshops (where appropriate)"], [:technical_rating,  "Technical requirements"], [:value_rating, "Value for money"], [:pre_show_rating, "Pre-show liaison"], [:marketing_rating, "Marketing materials"], [:audience_rating, "Audience reaction to show"]]