module Organisation
  
  def self.included(base)
    base.send(:include, YmCore::Model)

    base.has_many :posts, :as => :target

    base.has_snippets :website_url, :facebook_url, :twitter_name

    base.validates :name, :presence => true
    
    base.validates :website_url, :facebook_url, :url => true, :allow_blank => true

    base.validates :twitter_name, :format => {:with => /^\s*@?\w+\s*$/, :allow_blank => true}
    
    base.image_accessor :image
  end  

  def twitter_url
    twitter_name.present? ? "http://twitter.com/#{twitter_name.strip.sub(/@/, '')}" : ''
  end
  
end