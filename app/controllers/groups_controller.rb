class GroupsController < ApplicationController
  load_and_authorize_resource
  
  def create
    @goup = Group.new(params[:group])
    if @group.save
      flash.notice = "The group '#{@group}' has been created"
      redirect_to groups_path
    else
      flash.error = "Something's gone wrong - please try again"
      render :new
    end
  end

  def destroy
    if @group.destroy
      flash.notice = "The group '#{@group}' has been deleted"
    else
      flash.error = "Something's gone wrong -'#{@group}' wasn't been deleted"
    end
    redirect_to groups_path
  end

  def index
    @top_tags = Group.top_tags
  end
  
  def show
    @posts = @group.posts.page(params[:page])
    @top_tags = Group.top_tags.where(:groups => {:id => @group.id})
  end

  def update
    if @group.update_attributes(params[:group])
      flash.notice = "The group '#{@group}' has been updated"
      redirect_to groups_path
    else
      flash.error = "Something's gone wrong - please try again"
      render :new
    end
    
  end
  
end