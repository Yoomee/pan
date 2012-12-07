class Group < ActiveRecord::Base
  
  validates :name, :presence => true
  
  has_many :posts, :as => :target
  
  has_many :group_members
  has_many :members, :through => :group_members, :class_name => "User", :source => :user
  belongs_to :promoter
  
  scope :without, lambda {|groups| where("id NOT IN (?)", groups)}
  
  class << self
    def top_tags
      Tag.most_used.joins(:taggings).joins("JOIN posts ON posts.id = taggings.taggable_id AND taggings.taggable_type = 'Post'").joins("JOIN groups ON groups.id = posts.target_id AND posts.target_type = 'Group'") 
    end
  end
  
  def can_be_seen_by?(user)
    user.try(:is_admin?) || promoter.nil? || user.promoter == promoter
  end
  
  def set_notifications_to_read!(user)
    notification_ids = Notification.where(:context => 'my_groups', :resource_type => 'Post', :user_id => user.id)
                                   .collect{|n| n.id if n.resource.target == self}
    notification_ids << Notification.where(:context => 'my_groups', :resource_type => 'Comment', :user_id => user.id)
                                    .collect{|n| n.id if n.resource.post.target == self}
     Notification.where(:id => notification_ids).update_all(:read => true)
  end

  def to_s
    name
  end
  
end
