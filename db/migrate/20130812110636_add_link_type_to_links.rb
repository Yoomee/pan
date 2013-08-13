class AddLinkTypeToLinks < ActiveRecord::Migration
  def change
    add_column :links, :link_type, :string, :after => :host
    Link.all.each do |link|      
      case link.host
      when 'facebook.com'
        link.update_attribute(:link_type, 'facebook')
      when 'youtube.com'
        link.update_attribute(:link_type, 'youtube')
      when 'twitter.com'
        link.update_attribute(:link_type, 'twitter')
      else
        link.update_attribute(:link_type, 'other')        
      end
    end
  end
end
