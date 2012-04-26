class ResourcesController < ApplicationController
    
  expose(:resource)
  expose(:resources) {current_tag ? Resource.tagged_with(current_tag) : Resource.scoped}
  expose(:top_tags) {Resource.tag_counts_on(:resource_tags, :limit => 10)}
  expose(:current_tag) {Tag.find_by_name(params[:tag])}
  
  def create
    resource.user = current_user
    if resource.save
      flash_notice(resource)
      redirect_to resource
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
  
  def update
    if resource.save
      flash_notice(resource)
      redirect_to resource
    else
      render :action => "edit"
    end
  end
  
end