class ResourcesController < ApplicationController
    
  expose(:resource)
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
    @resources = current_tag ? Resource.tagged_with(current_tag) : Resource.scoped
  end
  
  def destroy
    flash_notice(resource)
    redirect_to resources_path
  end
  
  def search
    @query = strip_tags(params[:q]).to_s.strip
    if @query.present?
      @resources = Resource.search(@query)
    else
      @resources = []
    end
    render :action => "index"
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