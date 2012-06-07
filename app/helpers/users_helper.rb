module UsersHelper
  
  def logged_in_as_performer?(performer)
    return false if performer.nil?
    current_user.try(:performer) == performer
  end
  
end