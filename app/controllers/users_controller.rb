class UsersController < ApplicationController
  
  include YmUsers::UsersController
  
  expose(:wall_posts) {user.wall_posts.page(params[:page])}
  expose(:promoter) {Promoter.find_by_id(params[:promoter_id])}
  
  def new
  end
  
  def create
    user.promoter = promoter
    if user.save
      redirect_to(user)
    else
      render :action => "new"
    end
  end
  
end