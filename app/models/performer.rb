class Performer < ActiveRecord::Base

  include YmLikes::Likeable
  include YmActivity::Recordable
  include Organisation
  include HasLinks
  include HasReviews

  define_index do
    indexes name, :sortable => true
    indexes description
    indexes genre_tags(:name), :as => :genres
    has created_at, updated_at
    set_property :delta => true
  end

  image_accessor :image
  acts_as_taggable_on :genres, :art_forms, :funders, :work_scales, :categories, :tags
  has_many :genre_tags, :through => :taggings, :source => :tag, :class_name => "ActsAsTaggableOn::Tag",
          :conditions => "taggings.context = 'genres'"

  validates :description, length: {maximum: 1000}


  has_many :posts, :as => :target, :conditions => {:is_update => false}
  has_many :updates, :class_name => "Post", :as => :target, :conditions => {:is_update => true}
  has_many :tours, :dependent => :destroy
  has_many :tour_dates, :through => :tours, :source => :dates, :order => "date ASC"
  has_many :venues, :through => :tour_dates, :uniq => true

  has_many :performer_users, :dependent => :destroy
  has_many :users, :through => :performer_users

  has_many :notifications, :as => :resource, :dependent => :destroy

  has_many :external_reviews, :as => :reviewable, :dependent => :destroy
  accepts_nested_attributes_for :external_reviews, :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :users

  has_snippets :contact1_name, :contact1_email, :contact1_phone, :contact2_name, :contact2_email, :contact2_phone

  validates :contact1_email, :contact2_email, :email => true, :allow_blank => true
  validate :validate_user, :if => :new_record?

  after_update :create_notifications_if_favourite

  boolean_accessor :create_user_from_performer
  attr_accessor :contact1_password

  before_create :create_user, :if => lambda{|u| u.create_user_from_performer == true}

  def create_user
    name = split_name(contact1_name)
    self.users << User.new(:first_name => name[0], :last_name => name[1], :email => contact1_email, :password => contact1_password)
  end

  def validate_user
    name = split_name(contact1_name)
    new_user = User.new(:first_name => name[0], :last_name => name[1], :email => contact1_email, :password => contact1_password)
    unless new_user.valid?
      self.errors.add(:contact1_email, 'Email invalid, or this user already exists') if new_user.errors.messages.keys.include?(:email)
      self.errors.add(:contact1_name, 'Name invalid') if new_user.errors.messages.keys.include?(:first_name) || new_user.errors.messages.keys.include?(:last_name)
      self.errors.add(:contact1_password, 'Password invalid') if new_user.errors.messages.keys.include?(:password)
    end

  end

  def split_name(name)
    name = name.blank? ? [""] : name.split(' ')     
    name.push('n/a') if name.count == 1
    name
  end

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

  private
  def create_notifications_if_favourite
    likers.each do |liker|
      notifications.create(:user => liker, :context => "favourite_updated")
    end
  end

end
