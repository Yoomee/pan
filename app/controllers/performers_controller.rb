class PerformersController < ApplicationController
  
  expose(:performer)
  expose(:posts) {performer.posts.page(params[:page])}

  def create
    if performer.save
      flash_notice(performer)
      redirect_to(performer)
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
    @letter = params[:letter].to_s.first.upcase.presence || 'A'
    if @letter != params[:letter]
      redirect_to directory_performers_path(:letter => @letter)
    else
      if @letter =~ /^[a-zA-Z]/
        @performers = @performers.where("name LIKE?","#{@letter}%")
      else
        @letter = '#'
        @performers = @performers.where("name REGEXP '^[^a-zA-Z]'")
      end
      render :action => "index"
    end
  end
  
  def edit
  end
  
  def index
    @performers = Performer.order(:created_at)
  end
  
  def new
  end
  
  def search
    @query = strip_tags(params[:q]).to_s.strip
    if @query.present?
      @performers = Performer.search(@query)
    else
      @performers = []
    end
    render :action => "index"
  end
  
  def show
    
  end
  
  def update
    if performer.save
      flash_notice(performer)
      redirect_to(performer)
    else
      render :action => 'edit'
    end
  end
  
end