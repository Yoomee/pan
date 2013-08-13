class Promoter < ActiveRecord::Base
  
  include Organisation
  include HasLinks

  after_create :create_private_group
  
  define_index do
    indexes name, :sortable => true
    indexes description
    indexes genre_tags(:name), :as => :genres
    indexes region
    has created_at, updated_at
  end

  acts_as_taggable_on :genres, :art_forms, :genre_interests, :art_form_interests, :funders, :audiences, :marketing_resources, :pr_resources, :equipment, :hireable_resources, :skills, :skills_needed, :skills_need_training, :skills_underused, :skills_offered
  has_many :genre_tags, :through => :taggings, :source => :tag, :class_name => "ActsAsTaggableOn::Tag",
          :conditions => "taggings.context = 'genres'"
  
  has_many :users, :dependent => :nullify
  has_many :venues, :dependent => :destroy
  
  validates :region, :presence => true
  validates :email, :email => true, :allow_blank => true
  
  def address(options={})
    options.reverse_merge!(:country=>true)
    fields = %w{address1 address2 city postcode}
    fields << "country" if options[:country]
    fields.map {|fld| send(fld)}.select(&:present?).join(', ')
  end  
  
  def create_private_group
    group = Group.new(:name => name, :promoter => self, :description => "This is a private group for members of #{name.strip}.")
    group.save
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
      Pan::REGIONS[region_url]
    end
  end
  
end