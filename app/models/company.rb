class Company < ActiveRecord::Base
  
  include YmCore::Model
  
  has_many :posts, :as => :target
  
  validates_presence_of :name
  image_accessor :image
  
end