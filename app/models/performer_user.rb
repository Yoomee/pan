class PerformerUser < ActiveRecord::Base
  belongs_to :performer
  belongs_to :user

  validates :performer, :user, :presence => true
end
