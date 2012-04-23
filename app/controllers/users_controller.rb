class UsersController < ApplicationController
  
  include YmUsers::UsersController
  
  expose(:wall_posts) {user.wall_posts.page(params[:page])}
  expose(:promoter)
  
  def new
    user.promoter = promoter
  end
  
  def create
    if user.promoter && cannot?(:update,user.promoter)
      user.promoter = nil
    end
    if user.save
      redirect_to(user)
    else
      render :action => "new"
    end
  end
  
end