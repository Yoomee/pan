class ResourcesController < ApplicationController
  
  expose(:posts) {Post.resources.page(params[:page])}
  expose(:top_tags) {Post.tag_counts_on(:tags, :limit => 10)}
  
  def index
    render :template => "posts/index"
  end
  
end