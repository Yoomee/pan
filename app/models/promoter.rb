class Promoter < ActiveRecord::Base
  
  include Organisation

  acts_as_taggable_on :genres, :art_forms, :genre_interests, :art_form_interests, :funders, :audiences, :marketing_resources, :pr_resources, :equipment, :hireable_resources
  
  has_many :users, :dependent => :nullify
  has_many :venues, :dependent => :destroy
  
  has_snippets :address1, :address2, :address3, :address4, :postcode, :phone, :region, :email
  
  validates :region, :presence => true
  validates :email, :email => true, :allow_blank => true
  
  acts_as_taggable_on :skills, :skills_needed, :skills_need_training, :skills_underused, :skills_offered
  
  def address
    %w{address1 address2 address3 address4 postcode}.map {|fld| send(fld)}.select(&:present?).join(', ')
  end
  
end