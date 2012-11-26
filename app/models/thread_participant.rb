class ThreadParticipant < ActiveRecord::Base
  belongs_to :message_thread
  belongs_to :participant, :class_name => "User"
end
