module HasLinks
  
  def self.included(base)
    base.has_many :links, :as => :attachable, :conditions => {:link_type => 'other'}, :dependent => :destroy
    base.accepts_nested_attributes_for :links, :reject_if => :all_blank, :allow_destroy => true
    base.has_one :facebook_link, :class_name => 'Link', :as => :attachable, :conditions => {:link_type => 'facebook'}, :autosave => true
    base.has_one :twitter_link, :class_name => 'Link', :as => :attachable, :conditions => {:link_type => 'twitter'}, :autosave => true
    base.has_one :youtube_link, :class_name => 'Link', :as => :attachable, :conditions => {:link_type => 'youtube'}, :autosave => true
    base.has_one :website_link, :class_name => 'Link', :as => :attachable, :conditions => {:link_type => 'website'}, :autosave => true
    base.accepts_nested_attributes_for :facebook_link, :reject_if => :all_blank
    base.accepts_nested_attributes_for :twitter_link, :reject_if => :all_blank
    base.accepts_nested_attributes_for :youtube_link, :reject_if => :all_blank
    base.accepts_nested_attributes_for :website_link, :reject_if => :all_blank
  end

  def build_social_links
    build_facebook_link unless facebook_link
    build_twitter_link unless twitter_link
    build_youtube_link unless youtube_link
    build_website_link unless website_link
  end
  
  def facebook_url
    url = facebook_link.try(:url).try(:gsub, 'http://', '')
    url
  end

  def twitter_url
    url = twitter_link.try(:url).try(:gsub, 'http://', '')
    url
  end

  def youtube_url
    url = youtube_link.try(:url).try(:gsub, 'http://', '')
    url
  end

  def website_url
    url = website_link.try(:url).try(:gsub, 'http://', '')
    url  
  end

  def addwww(url)
    unless url.blank?    
      url.insert(0, 'www.') unless url.start_with?('www.')
    end
  end   

  def social_urls
    %w{facebook twitter youtube vimeo soundcloud}.collect do |site_name|
      url = send("#{site_name}_url")
      [site_name.humanize, url] if url.present?
    end.compact
  end

  # def twitter_url
  #   @twitter_url ||= links.find_by_host('twitter.com').try(:url)
  # end

  # def youtube_url
  #   @youtube_url ||= links.find_by_host('youtube.com').try(:url)
  # end
  
  def twitter_username
    @twitter_username ||= twitter_url.nil? ? '' : twitter_url.scan(/twitter\.com\/(#!\/)?(\w*)/).flatten.last
  end
  
end