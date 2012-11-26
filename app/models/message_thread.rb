class MessageThread < ActiveRecord::Base
  has_many :thread_participants
  has_many :participants, :through => :thread_participants
  has_many :messages
end
