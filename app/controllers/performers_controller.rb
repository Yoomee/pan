class PerformersController < ApplicationController

  load_and_authorize_resource
  
  expose(:performer)
  expose(:posts) {performer.posts.page(params[:page])}

  def create
    if performer.errors.count == 0 #errors from trying to save new performer user
      if performer.save
        current_user.record_activity!(performer)
        flash_notice(performer)
        redirect_to(performer)
      else
        render :action => 'new'
      end
    else
      render :action => 'new'
    end
  end

  def destroy
    performer.destroy
    flash_notice(performer)
    redirect_to(performers_path)
  end
  
  def directory
    @performers = Performer.order('name')
    @letter = params[:letter].to_s.first.upcase.presence || Performer.present_directory_letters.first
    if @letter != params[:letter]
      redirect_to directory_performers_path(:letter => @letter)
    else
      if @letter =~ /^[a-zA-Z]/
        @performers = @performers.where("name LIKE?","#{@letter}%")
      else
        @letter = '#'
        @performers = @performers.where("name REGEXP '^[^a-zA-Z]'")
      end
      @tags = [*params[:tags]]
      render :template => 'organisations/directory'
    end
  end
  
  def index
    if (@tag_context = params[:tag_context]).present?
      if (@tag = params[:tags]).present?
        @performers = Performer.tagged_with(@tag, :on => @tag_context)
      else
        @tags = Performer.tag_counts_on(@tag_context)
      end
    else
      @performers = Performer.order("created_at DESC").limit(10)
    end
    @tags = params[:tags]
    render :template => 'organisations/directory'
  end
  
  def rating  
    @performers = Performer.order_by_ratings
    render :template => 'organisations/directory'
  end
  
  def edit
    performer.build_social_links
  end

  def new
    performer.build_social_links
  end
  
  def search
    @query = strip_tags(params[:q]).to_s.strip
    if @query.present?
      @performers = Performer.search(@query)
    else
      @performers = []
    end
    @tags = params[:tags]
    render :template => 'organisations/directory'
  end
  
  def show
    
  end
  
  def update
    if @performer.update_attributes(params[:performer])
      flash_notice(@performer)
      redirect_to(@performer)
    else
      render :action => 'edit'
    end
  end
  
end