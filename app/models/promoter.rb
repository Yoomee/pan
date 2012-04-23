class Promoter < ActiveRecord::Base
  
  include Organisation

  acts_as_taggable_on :genres, :art_forms
  
  has_many :users, :dependent => :nullify
  has_many :venues, :dependent => :destroy
  
  has_snippets :address1, :address2, :address3, :address4, :postcode, :phone, :region, :email
  
  validates :region, :presence => true
  validates :email, :email => true, :allow_blank => true
  
  def address
    %w{address1 address2 address3 address4 postcode}.map {|fld| send(fld)}.select(&:present?).join(', ')
  end
  
end