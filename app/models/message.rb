class Message < ActiveRecord::Base
  belongs_to :thread, :class_name => "MessageThread", :foreign_key => :message_thread_id
  belongs_to :user

  has_many :notifications, :as => :resource, :dependent => :destroy
  attr_accessor :recipient_id

  after_create :create_notifications

  private
  def create_notifications
    thread.participants.where('participant_id != ?', user.id).each do |participant|
      notifications.create(:user => participant, :context => "messages")
    end
  end

end
