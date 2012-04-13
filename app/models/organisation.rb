module Organisation
  
  def self.included(base)
    base.send(:include, YmCore::Model)

    base.has_many :posts, :as => :target

    base.validates_presence_of :name
    
    base.image_accessor :image
  end  
  
end