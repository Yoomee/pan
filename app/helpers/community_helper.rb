module CommunityHelper
  
  def viewing_community?
    %w{users posts}.include?(controller_name)
  end
  
end