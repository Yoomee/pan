class Promoter < ActiveRecord::Base
  
  include Organisation

  define_index do
    indexes name, :sortable => true
    indexes description
    has created_at, updated_at
  end

  acts_as_taggable_on :genres, :art_forms, :genre_interests, :art_form_interests, :funders, :audiences, :marketing_resources, :pr_resources, :equipment, :hireable_resources, :skills, :skills_needed, :skills_need_training, :skills_underused, :skills_offered
  
  has_many :users, :dependent => :nullify
  has_many :venues, :dependent => :destroy
  
  validates :region, :presence => true
  validates :email, :email => true, :allow_blank => true
  
  def address
    %w{address1 address2 city postcode country}.map {|fld| send(fld)}.select(&:present?).join(', ')
  end  
  
  def country
    "UK"
  end
  
end