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
  
  def resources_present?
    [:marketing_resource_list, :pr_resource_list, :equipment_list, :hireable_resource_list].any?{|list| !send(list).empty?}
  end
  
  def skills_present?
    [:skills, :skills_needed, :skills_need_training, :skills_underused, :skills_offered].any?{|list| !send(list).empty?}
  end
  
  class << self
    def region_from_url(region_url)
      Pan::REGIONS.each.collect { |region| region if region.to_url == region_url }.compact[0]
    end
  end
  
end