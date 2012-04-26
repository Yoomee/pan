class Resource < ActiveRecord::Base
  
  belongs_to :user
  
  acts_as_taggable_on :resource_tags
  
  has_pdf
  
  validates :name, :file, :presence => true
  
end