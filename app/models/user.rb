class User < ActiveRecord::Base
  include YmUsers::User
  belongs_to :promoter
  has_many :venues, :dependent => :nullify
end