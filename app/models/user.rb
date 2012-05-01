class User < ActiveRecord::Base
  include YmUsers::User
  
  define_index do
    indexes first_name, :sortable => true
    indexes last_name, :sortable => true
    indexes bio
    has role, created_at, updated_at
  end
  
  belongs_to :promoter
  has_many :venues, :dependent => :nullify

  has_many :links, :as => :attachable, :dependent => :destroy
  accepts_nested_attributes_for :links, :reject_if => :all_blank, :allow_destroy => true  
  
  acts_as_taggable_on :skills
  acts_as_taggable_on :skills_offered
  acts_as_taggable_on :skills_needed
  
  def self.present_directory_letters
    order(:last_name).select("UCASE(SUBSTR(last_name,1,1)) AS letter").group("SUBSTR(last_name,1,1)").collect(&:letter)
  end
  
  def description
    bio
  end
  
end