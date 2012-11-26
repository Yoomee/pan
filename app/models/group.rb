class Group < ActiveRecord::Base
  
  validates :name, :presence => true
  
  has_many :posts, :as => :target
  
  has_many :group_members
  has_many :members, :through => :group_members, :class_name => "User", :source => :user
  
  scope :without, lambda {|groups| where("id NOT IN (?)", groups)}
  
  class << self
    def top_tags
      Tag.most_used.joins(:taggings).joins("JOIN posts ON posts.id = taggings.taggable_id AND taggings.taggable_type = 'Post'").joins("JOIN groups ON groups.id = posts.target_id AND posts.target_type = 'Group'") 
    end
  end
  
  def to_s
    name
  end
  
end
