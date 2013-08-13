module Organisation
  
  def self.included(base)
    base.send(:include, YmCore::Model)
    base.extend(ClassMethods)
    base.image_accessor :image
    
    base.has_slideshow

    base.has_many :posts, :as => :target    
      
    base.validates :name, :presence => true
    base.send(:validates_property, :format, :of => :image, :in => [:jpeg, :jpg, :png, :gif], :message => "must be an image", :case_sensitive => false)
  end 
  
  module ClassMethods
    def present_directory_letters
      order(:name).select("UCASE(SUBSTR(name,1,1)) AS letter").group("SUBSTR(name,1,1)").collect(&:letter)
    end
  end
  
end