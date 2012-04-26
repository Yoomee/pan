class User < ActiveRecord::Base
  include YmUsers::User
  belongs_to :promoter
  has_many :venues, :dependent => :nullify
  has_many :links, :as => :attachable, :dependent => :destroy
  accepts_nested_attributes_for :links, :reject_if => :all_blank, :allow_destroy => true  
  
  acts_as_taggable_on :skills
  acts_as_taggable_on :skills_offered
  acts_as_taggable_on :skills_needed
  
end