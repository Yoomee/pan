class User < ActiveRecord::Base
  include YmUsers::User
  belongs_to :promoter
end