class User < ActiveRecord::Base
  
  include YmUsers::User
  include YmCore::Multistep
  
  define_index do
    indexes first_name, :sortable => true
    indexes last_name, :as => :name, :sortable => true
    indexes bio
    has role, created_at, updated_at
  end
  
  belongs_to :performer, :autosave => true
  belongs_to :promoter, :autosave => true
  
  has_many :venues, :dependent => :nullify

  has_many :links, :as => :attachable, :dependent => :destroy
  accepts_nested_attributes_for :links, :reject_if => :all_blank, :allow_destroy => true  
  
  has_many :reviews, :dependent => :nullify
  
  has_many :group_members
  has_many :groups, :through => :group_members

  has_many :group_notifications, :class_name => "Notification", :conditions => {:context => "my_groups", :read => false}

  has_many :thread_participants, :foreign_key => :participant_id, :dependent => :destroy
  has_many :threads, :through => :thread_participants, :source => :message_thread
  has_many :messages, :dependent => :destroy

  has_many :message_notifications, :class_name => "Notification", :conditions => {:context => "messages", :read => false}

  acts_as_taggable_on :skills, :skills_offered, :skills_needed
  
  before_create :create_organisation, :set_role
  
  attr_writer :organisation_type, :organisation_name
  boolean_accessor :stepping_back
  
  has_roles :admin, :promoter_staff, :promoter_admin
  
  validates_presence_of :organisation_name, :if => lambda{|u| !u.stepping_back? && u.organisation_type == 'performer' && u.current_step_gte("organisation_details")}
  validates_presence_of :promoter, :if => lambda{|u| !u.stepping_back? && u.organisation_type == 'promoter' && u.current_step_gte("organisation_details")}
  
  validate :only_has_one_organisation
  
  def self.present_directory_letters
    order(:last_name).select("UCASE(SUBSTR(last_name,1,1)) AS letter").group("SUBSTR(last_name,1,1)").collect(&:letter)
  end
  
  def description
    bio
  end
  alias_method :summary, :description
  
  def facebook_url
    @facebook_url ||= links.find_by_host('facebook.com').try(:url)
  end

  def links_only_twitter_and_facebook
    links.where("host = 'facebook.com' OR host = 'twitter.com'")
  end
  
  def links_without_twitter_and_facebook
    links.where("host != 'facebook.com' AND host != 'twitter.com'")
  end
  
  def name
    [first_name, last_name].join(' ')
  end
  
  def organisation_name
    @organisation_name.presence || performer.try(:name) || promoter.try(:name)
  end
  
  def organisation_type
    case
    when @organisation_type.present?
      @organisation_type
    when performer.present?
      'performer'
    when promoter.present?
      'promoter'
    end
  end
  
  def steps
    %w{user_details organisation_type organisation_details}
  end 

  def twitter_url
    @twitter_url ||= links.find_by_host('twitter.com').try(:url)
  end
  
  def twitter_username
    @twitter_username ||= twitter_url.nil? ? '' : twitter_url.scan(/twitter\.com\/(#!\/)?(\w*)/).flatten.last
  end
  
  private
  def create_organisation
    if @organisation_type == 'performer' && performer.nil? && promoter.nil?
      self.create_performer(:name => organisation_name)
    end
  end
  
  def only_has_one_organisation
    if performer.present? && promoter.present?
      errors.add(:promoter, "can't have a promoter and a performer")
    end
  end
  
  def set_role
    return true if role.present?
    if promoter.present?
      self.role = "promoter_staff"
    end
    true
  end
  
end