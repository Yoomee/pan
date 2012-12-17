class Performer < ActiveRecord::Base
  
  include YmLikes::Likeable
  include Organisation
  include HasReviews
  
  define_index do
    indexes name, :sortable => true
    indexes description
    indexes genre_tags(:name), :as => :genres
    has created_at, updated_at
  end
  
  image_accessor :image
  acts_as_taggable_on :genres, :art_forms, :funders, :work_scales, :categories, :tags
  has_many :genre_tags, :through => :taggings, :source => :tag, :class_name => "ActsAsTaggableOn::Tag",
          :conditions => "taggings.context = 'genres'"
  
  has_many :posts, :as => :target
  has_many :tours, :dependent => :destroy
  has_many :tour_dates, :through => :tours, :source => :dates, :order => "date ASC"
  has_many :venues, :through => :tour_dates, :uniq => true
  has_many :users, :dependent => :nullify
  
  has_many :notifications, :as => :resource, :dependent => :destroy

  has_many :external_reviews, :as => :reviewable, :dependent => :destroy
  accepts_nested_attributes_for :external_reviews, :reject_if => :all_blank, :allow_destroy => true
  
  has_snippets :contact1_name, :contact1_email, :contact1_phone, :contact2_name, :contact2_email, :contact2_phone
  
  validates :contact1_email, :contact2_email, :email => true, :allow_blank => true
  
  after_update :create_notifications_if_favourite
  
  def contact1_details
    [contact1_name, contact1_email, contact1_phone].compact
  end
  
  def contact2_details
    [contact2_name, contact2_email, contact2_phone].compact
  end
  
  def current_tour
    tours.order(:end_on).where("end_on > :now", now: Time.now).first
  end  
  
  def future_tours
    tours.order(:end_on).where("end_on > :now", now: Time.now).drop(1)
  end
  
  def social_urls
    %w{facebook twitter youtube vimeo soundcloud}.collect do |site_name|
      url = send("#{site_name}_url")
      [site_name.humanize, url] if url.present?
    end.compact
  end

  def links_only_twitter_and_facebook
    links.where("host = 'facebook.com' OR host = 'twitter.com'")
  end
  
  def links_without_twitter_and_facebook
    links.where("host != 'facebook.com' AND host != 'twitter.com'")
  end
  
  private
  def create_notifications_if_favourite
    likers.each do |liker|
      notifications.create(:user => liker, :context => "favourite_updated")
    end
  end
  
end