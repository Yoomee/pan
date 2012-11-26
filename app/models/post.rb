class Post < ActiveRecord::Base
  
  include YmPosts::Post

  has_many :notifications, :as => :resource, :dependent => :destroy
  
  after_create :add_user_to_group
  after_create :create_notifications

  private
  def add_user_to_group
    if target_type == "Group" && !Group.find(target_id).members.include?(user)
      Group.find(target_id).members << user  
    end
  end

  def create_notifications
    if target_type == "Group"
      Group.find(target_id).members.each do |member|
        notifications.create(:user => member, :context => "my_groups") unless member == user
      end
    end
  end
  
end