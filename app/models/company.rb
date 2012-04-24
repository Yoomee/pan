class Company < ActiveRecord::Base
  
  include YmCore::Model
  include Organisation  
  
  image_accessor :image
  acts_as_taggable_on :genres, :art_forms, :funders  
  
  has_many :posts, :as => :target
  has_many :tours, :dependent => :destroy
  has_many :tour_dates, :through => :tours, :source => :dates
  
  has_snippets :contact1_name, :contact1_email, :contact1_phone, :contact2_name, :contact2_email, :contact2_phone, :youtube_url, :vimeo_url, :soundcloud_url
  
  validates :contact1_email, :contact2_email, :email => true, :allow_blank => true
  validates :youtube_url, :vimeo_url, :soundcloud_url, :url => true, :allow_blank => true
  
  def contact1_details
    [contact1_name, contact1_email, contact1_phone].compact
  end
  
  def contact2_details
    [contact2_name, contact2_email, contact2_phone].compact
  end
  
  def social_urls
    %w{facebook twitter youtube vimeo soundcloud}.collect do |site_name|
      url = send("#{site_name}_url")
      [site_name.humanize, url] if url.present?
    end.compact
  end
  
end