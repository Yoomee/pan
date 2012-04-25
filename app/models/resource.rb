class Resource < ActiveRecord::Base
  
  belongs_to :user
  
  acts_as_taggable
  has_pdf
  
  def to_s
    file_name
  end
  
  def summary
    file_intro
  end
  
end