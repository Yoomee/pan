module CommunityHelper
  
  def viewing_community?
    %w{users posts venues}.include?(controller_name)
  end
  
end