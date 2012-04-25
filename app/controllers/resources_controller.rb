class ResourcesController < ApplicationController
    
  expose(:resource)
  expose(:resources) {Resource.scoped}  
  expose(:top_tags) {Resource.tag_counts_on(:tags, :limit => 10)}
  
  def create
    if resource.save
      flash_notice(resource)
      redirect_to resources_path
    else
      render :action => "new"
    end
  end
  
  def index
  end
  
  def destroy
    flash_notice(resource)
    redirect_to resources_path
  end
  
end