class ExternalReview < ActiveRecord::Base
  
  belongs_to :reviewable, :polymorphic => true
  
end
