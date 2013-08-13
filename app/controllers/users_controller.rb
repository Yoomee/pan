class UsersController < ApplicationController
  
  include YmUsers::UsersController
  load_and_authorize_resource


  after_filter :set_notifications_to_read, :only => :show
  

  expose(:wall_posts) {user.wall_posts.page(params[:page])}
  expose(:promoter) {Promoter.find_by_id(params[:promoter_id])}
  
  def new
    user.build_social_links
  end

  def edit
    user.build_social_links
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
    @users = User.order([:last_name, :first_name]).where(:performer_id => nil)
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
      @tags = [*params[:tags]]
      render :template => 'organisations/directory'
    end
  end
  
  def index
    if (@tag_context = params[:tag_context]).present? && (@tag = params[:tag]).present?
      @users = User.tagged_with(@tag, :on => @tag_context)
    else    
      @users = User.order("created_at DESC").limit(10)
    end
    @users = @users.where(:performer_id => nil)
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
  
  def show
    if user.performer
      redirect_to(user.performer)
    end
  end
  
  def update_role
    if user.update_attribute(:role, params[:role])
      UserMailer.new_admin(user).deliver if user.promoter_admin?
      flash[:notice] = "#{user} updated"
    else
      flash[:error] = "#{user} could not be updated"
    end
    if params[:role].match(/promoter/)
      redirect_to individuals_promoters_path
    else
      redirect_to users_path
    end
  end

  private
  def set_notifications_to_read
    if user == current_user
      user.set_notifications_as_read!
    end
  end
  
end