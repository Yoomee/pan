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
  
  def directory
    @users = User.order([:last_name,:first_name])
    @letter = params[:letter].to_s.first.upcase.presence || User.present_directory_letters.first
    if @letter != params[:letter]
      redirect_to directory_users_path(:letter => @letter)
    else
      if @letter =~ /^[a-zA-Z]/
        @users = @users.where("last_name LIKE?","#{@letter}%")
      else
        @letter = '#'
        @users = @users.where("last_name REGEXP '^[^a-zA-Z]'")
      end
      render :template => 'organisations/directory'
    end
  end
  
  def index
    @users = User.order("created_at DESC").limit(10)
    render :template => 'organisations/directory'
  end
  
  def search
    @query = strip_tags(params[:q]).to_s.strip
    if @query.present?
      @users = User.search(@query)
    else
      @users = []
    end
    render :template => 'organisations/directory'
  end
  
  
end