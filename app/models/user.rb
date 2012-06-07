class User < ActiveRecord::Base
  
  include YmUsers::User
  include YmCore::Multistep
  
  define_index do
    indexes first_name, :sortable => true
    indexes last_name, :sortable => true
    indexes bio
    has role, created_at, updated_at
  end
  
  belongs_to :performer, :autosave => true
  belongs_to :promoter, :autosave => true
  
  has_many :venues, :dependent => :nullify

  has_many :links, :as => :attachable, :dependent => :destroy
  accepts_nested_attributes_for :links, :reject_if => :all_blank, :allow_destroy => true  

  acts_as_taggable_on :skills, :skills_offered, :skills_needed
  
  before_create :create_organisation
  
  attr_writer :organisation_type, :organisation_name
  boolean_accessor :stepping_back
  
  validates_presence_of :organisation_name, :if => lambda{|u| !u.stepping_back? && u.organisation_type == 'performer' && u.current_step_gte("organisation_details")}
  validates_presence_of :promoter, :if => lambda{|u| !u.stepping_back? && u.organisation_type == 'promoter' && u.current_step_gte("organisation_details")}
  
  validate :only_has_one_organisation
  
  def self.present_directory_letters
    order(:last_name).select("UCASE(SUBSTR(last_name,1,1)) AS letter").group("SUBSTR(last_name,1,1)").collect(&:letter)
  end
  
  def description
    bio
  end
  
  def facebook_url
    @facebook_url ||= links.find_by_host('facebook.com').try(:url)
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
  
end