class PromotersController < ApplicationController

  load_and_authorize_resource

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
      render :template => 'organisations/directory'
    end
  end
  
  def region
    @region_url = params[:region_url].presence || 'argyll-and-bute'
    @region = Promoter.region_from_url(@region_url)
    @promoters = Promoter.where(:region => @region).order(:name)
    render :template => 'organisations/region'
  end
  
  def index
    if (@tag_context = params[:tag_context]).present?
      if (@tag = params[:tag]).present?
        @promoters = Promoter.tagged_with(@tag, :on => @tag_context)
      else
        @tags = Promoter.tag_counts_on(@tag_context)        
      end
    else
      @promoters = Promoter.order("created_at DESC").limit(10)
    end
    render :template => 'organisations/directory'
  end
  
  def search
    @query = strip_tags(params[:q]).to_s.strip
    if @query.present?
      @promoters = Promoter.search(@query)
    else
      @promoters = []
    end
    render :template => 'organisations/directory'
  end

  def toggle_suspension
    if @promoter.update_attribute(:suspended, !@promoter.suspended?)
      flash[:notice] = "#{promoter} updated"
    else
      flash[:notice] = "#{promoter}} could not be updated"
    end
    redirect_to individuals_promoters_path
  end
  
  def edit
    promoter.build_social_links
  end
  
  def individuals;end  
  
  def new
    promoter.build_social_links
  end

  def show
    @dates =  TourDate.where(:booked => true,).where('date > ?', Date.today)
    @dates = @dates.where(:venue_id => Promoter.find(params[:id]).venues)    
  end
  
  def update
    if promoter.save
      flash_notice(promoter)
      redirect_to(promoter)
    else
      render :action => 'edit'
    end
  end
  
end