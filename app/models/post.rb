class Post < ActiveRecord::Base
  include YmPosts::Post
  
  default_scope where(:resource => false)  
  scope :resources, where(:resource => true)
  
end