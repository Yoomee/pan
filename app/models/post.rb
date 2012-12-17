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
    elsif target_type == "Tour" && is_update?
      target.performer.likers.each do |liker|
        target.notifications.create(:user => liker, :context => "tour_update_created")
      end
    elsif target_type == "Performer" && is_update?
      puts "here \n\n\n\n\n\n\n\n"
      target.likers.each do |liker|
        target.notifications.create(:user => liker, :context => "performer_update_created")
      end
    end
  end
  
end