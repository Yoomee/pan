class GroupsController < ApplicationController
  load_and_authorize_resource
  
  def index
    @top_tags = Group.top_tags
  end
  
  def show
    @posts = @group.posts.page(params[:page])
    @top_tags = Group.top_tags.where(:groups => {:id => @group.id})
  end
  
end