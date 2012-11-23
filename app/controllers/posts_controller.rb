class PostsController < ApplicationController
  
  include YmPosts::PostsController
  load_and_authorize_resource

  def show
    @group = Group.find(@post.target_id)
    @top_tags = Group.top_tags.where(:groups => {:id => @group.id})
    render 'groups/show'
  end
  
end