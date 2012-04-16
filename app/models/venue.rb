class Venue < ActiveRecord::Base
  
  include YmCore::Model
  
  include Organisation
  
  has_snippets :address1, :address2, :address3, :address4, :postcode, :phone, :region, :email
  
  validates :email, :email => true, :allow_blank => true
  validates :region, :presence => true
  
  belongs_to :promoter  
  
  def address
    %w{address1 address2 address3 address4 postcode}.map {|fld| send(fld)}.select(&:present?).join(', ')
  end
  
  def promoter=(promoter)
    # default to promoter's region
    self.region = promoter.region
  end
  
  
end