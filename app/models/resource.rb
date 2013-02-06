class Resource < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :target, :polymorphic => true  
  has_many :posts, :as => :target
  
  scope :publications, where("file_uid IS NOT NULL")
  scope :links, where("url !='' AND file_name IS NULL")
  scope :other, where("text != ''")
    
  acts_as_taggable_on :resource_tags
  has_doc
  
  validates :name, :summary, :presence => true
  
  define_index do
    indexes name
    indexes summary
    indexes file_text
    indexes publication_date
    indexes filename
    has user_id, created_at, updated_at
  end
  
  def is_publication?
    !file_uid.nil?
  end
  
  def is_link?
    url != "" && file_name.nil?
  end
  
  def is_other?
    !is_publication? && !is_link?
  end
  
end