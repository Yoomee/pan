class User < ActiveRecord::Base
  include YmUsers::User
  belongs_to :promoter
  has_many :venues, :dependent => :nullify
  
  acts_as_taggable_on :skills
  acts_as_taggable_on :skills_offered
  acts_as_taggable_on :skills_needed
  
end