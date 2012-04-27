module Organisation
  
  def self.included(base)
    base.send(:include, YmCore::Model)
    base.image_accessor :image

    base.has_many :posts, :as => :target    
  
    base.has_many :links, :as => :attachable, :dependent => :destroy
    base.accepts_nested_attributes_for :links, :reject_if => :all_blank, :allow_destroy => true  
    
    base.validates :name, :presence => true
    base.send(:validates_property, :format, :of => :image, :in => [:jpeg, :jpg, :png, :gif], :message => "must be an image")
  end 
  
  def facebook_url
    links.find_by_host('facebook.com').try(:url)
  end 

  def twitter_url
    links.find_by_host('twitter.com').try(:url)
  end 
  
end