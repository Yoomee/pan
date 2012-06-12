module UsersHelper
  
  def logged_in_as_performer?(performer)
    return false if performer.nil?
    current_user.try(:performer) == performer
  end
  
  def logged_in_as_promoter?(promoter)
    return false if promoter.nil?
    current_user.try(:promoter) == promoter
  end
  
  def logged_in_as_promoter_admin?(promoter)
    current_user.try(:promoter_admin?) && logged_in_as_promoter?(promoter)
  end
  
end