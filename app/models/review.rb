class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :performer
  belongs_to :tour
  
  validates :title, :description, :overall_rating, :user, :performer, :presence => true
  
  default_scope order("created_at DESC")
end