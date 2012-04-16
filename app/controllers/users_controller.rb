class UsersController < ApplicationController
  
  include YmUsers::UsersController
  
  expose(:wall_posts) {user.wall_posts.page(params[:page])}
  
end