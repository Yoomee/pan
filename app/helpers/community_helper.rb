module CommunityHelper
  
  def viewing_community?
    %w{users posts venues promoters}.include?(controller_name)
  end
  
end