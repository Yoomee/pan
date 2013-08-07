module Organisation
  
  def self.included(base)
    base.send(:include, YmCore::Model)
    base.extend(ClassMethods)
    base.image_accessor :image
    
    base.has_slideshow

    base.has_many :posts, :as => :target    
  
    base.has_many :links, :as => :attachable, :dependent => :destroy
    base.accepts_nested_attributes_for :links, :reject_if => :all_blank, :allow_destroy => true  
    
    base.validates :name, :presence => true
    base.send(:validates_property, :format, :of => :image, :in => [:jpeg, :jpg, :png, :gif], :message => "must be an image", :case_sensitive => false)
  end 
  
  module ClassMethods
    def present_directory_letters
      order(:name).select("UCASE(SUBSTR(name,1,1)) AS letter").group("SUBSTR(name,1,1)").collect(&:letter)
    end
  end
  
  def facebook_url
    @facebook_url ||= links.find_by_host('facebook.com').try(:url)
  end 

  def twitter_url
    @twitter_url ||= links.find_by_host('twitter.com').try(:url)
  end
  
  def twitter_username
    @twitter_username ||= twitter_url.nil? ? '' : twitter_url.scan(/twitter\.com\/(#!\/)?(\w*)/).flatten.last
  end
  
end