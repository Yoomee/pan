class Collection < ActiveRecord::Base
  has_and_belongs_to_many :tours

  validates_presence_of :name

  def to_s
    name
  end
  
end
