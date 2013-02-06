class ResourcesController < ApplicationController
    
  expose(:resource)
  expose(:top_tags) {Resource.tag_counts_on(:resource_tags, :limit => 10)}
  expose(:current_tag) {Tag.find_by_name(params[:tag])}
  expose(:posts) {resource.posts.page(params[:page])}
  
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
    @resources = current_tag ? Resource.tagged_with(current_tag) : Resource.publications
    @recent_resources = Resource.order("updated_at DESC").first(3)
    @resources_links = Resource.links
    @resources_other = Resource.other
    
  end

  def destroy
    flash_notice(resource)
    resource.destroy
    redirect_to resources_path
  end

  def download
    send_file(resource.file_path, :filename => "#{resource.name.parameterize}.#{resource.file_ext}")
  end

  def search
    @recent_resources = Resource.order("updated_at DESC").first(3)
    @query = strip_tags(params[:q]).to_s.strip
    if @query.present?
      @resources = Resource.publications.search(@query).reject{|resource| !resource.is_publication?}
      @resources_links = Resource.publications.search(@query).reject{|resource| !resource.is_link?}
      @resources_other = Resource.publications.search(@query).reject{|resource| !resource.is_other?}
    end
    render :action => "index"
  end
  
  def show
    @recent_resources = Resource.order("updated_at DESC").first(3)
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