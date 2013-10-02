class User < ActiveRecord::Base
  
  include YmUsers::User
  include YmCore::Multistep
  include HasLinks
  
  define_index do
    indexes first_name, :sortable => true
    indexes last_name, :as => :name, :sortable => true
    indexes bio
    has role, created_at, updated_at
    set_property :delta => true 
  end

  has_many :performer_users, :dependent => :destroy
  has_many :performers, :through => :performer_users
  
  belongs_to :promoter, :autosave => true
  
  has_many :venues, :dependent => :nullify
  
  has_many :reviews, :dependent => :nullify
  
  
  has_many :posts, :order => "created_at DESC", :conditions => {:is_update => false}, :dependent => :destroy
  has_many :updates, :class_name => "Post", :conditions => {:is_update => true}, :dependent => :destroy
  
  has_many :group_members
  has_many :groups, :through => :group_members

  has_many :message_thread_users, :foreign_key => :user_id, :dependent => :destroy
  has_many :threads, :through => :message_thread_users, :source => :message_thread
  has_many :messages, :dependent => :destroy

  has_many :message_notifications, :class_name => "Notification", :conditions => {:context => "messages", :read => false}
  has_many :other_notifications, :class_name => "Notification", :conditions => ['notifications.context != "messages" AND notifications.read = false']

  acts_as_taggable_on :skills, :skills_offered, :skills_needed
  
  before_create :create_organisation, :set_role
  
  attr_writer :organisation_type, :organisation_name
  boolean_accessor :stepping_back
  
  has_roles :admin, :promoter_staff, :promoter_admin
  
  validates_presence_of :organisation_name, :if => lambda{|u| !u.stepping_back? && u.organisation_type == 'performer' && u.current_step_gte("organisation_details")}
  validates_presence_of :promoter, :if => lambda{|u| !u.stepping_back? && u.organisation_type == 'promoter' && u.current_step_gte("organisation_details")}
  
  validate :only_has_one_organisation
  
  delegate :region, :to => :promoter, :allow_nil => true

  def self.present_directory_letters
    order(:last_name).select("UCASE(SUBSTR(last_name,1,1)) AS letter").group("SUBSTR(last_name,1,1)").collect(&:letter)
  end
  
  def description
    bio
  end
  alias_method :summary, :description
  
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

  def performer
    performers.present? ? performers.first : nil
  end

  def performer_id
    performers.present? ? performers.first.id : nil
  end

  def set_notifications_as_read!
    notifications.where("notifications.user_id = ?", self.id).update_all(:read => true)
  end
  
  def steps
    %w{user_details organisation_type organisation_details}
  end 

  def to_s    
    full_name    
  end
  
  private
  def create_organisation
    if @organisation_type == 'performer' && performer.nil? && promoter.nil?
      self.create_performer(:name => organisation_name)
    end
  end
  
  def only_has_one_organisation
    if performers.present? && promoter.present?
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