class PromotersController < ApplicationController

  expose(:promoters) {Promoter.order('name')}
  expose(:promoter)
  expose(:posts) {promoter.posts.page(params[:page])}
  
  def create
    if promoter.save
      flash_notice(promoter)
      redirect_to(promoter)
    else
      render :action => 'new'
    end
  end
  
  def destroy
    promoter.destroy
    flash_notice(promoter)
    redirect_to(promoters_path)
  end
  
  def directory
    @promoters = Promoter.order('name')
    @letter = params[:letter].to_s.first.upcase.presence || Promoter.present_directory_letters.first
    if @letter != params[:letter]
      redirect_to directory_promoters_path(:letter => @letter)
    else
      if @letter =~ /^[a-zA-Z]/
        @promoters = @promoters.where("name LIKE?","#{@letter}%")
      else
        @letter = '#'
        @promoters = @promoters.where("name REGEXP '^[^a-zA-Z]'")
      end
      render :template => 'layouts/directory'
    end
  end

  
  def index
    @promoters = Promoter.order("created_at DESC").limit(10)
    render :template => 'layouts/directory'
  end
  
  def search
    @query = strip_tags(params[:q]).to_s.strip
    if @query.present?
      @promoters = Promoter.search(@query)
    else
      @promoters = []
    end
    render :template => 'layouts/directory'
  end
  
  def edit;end
  
  
  def new;end

  def show;end
  
  def update
    if promoter.save
      flash_notice(promoter)
      redirect_to(promoter)
    else
      render :action => 'edit'
    end
  end
  
end