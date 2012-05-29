class Resource < ActiveRecord::Base
  
  belongs_to :user  
  has_many :posts, :as => :target
    
  acts_as_taggable_on :resource_tags
  has_doc
  
  validates :name, :file, :presence => true
  
  define_index do
    indexes name, :sortable => true
    indexes summary
    indexes file_text
    has user_id, created_at, updated_at
  end
  
  
end