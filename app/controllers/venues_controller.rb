class VenuesController < ApplicationController

  load_and_authorize_resource

  expose(:venue)
  expose(:venues) {Venue.all}
  expose(:posts) {venue.posts.page(params[:page])}
  
  def bookings
  end
  
  def create
    if venue.save
      current_user.record_activity!(venue)
      flash_notice(venue)
      redirect_to(venue)
    else
      render :action => 'new'
    end
  end
  
  def destroy
    venue.destroy
    flash_notice(venue)
    redirect_to(venue.promoter)
  end

  def edit
    promoter = Promoter.find(params[:promoter_id])
    promoter.build_social_links
  end
  
  def location;end
  
  def directory
    @venues = Venue.order('name')
    @letter = params[:letter].to_s.first.upcase.presence || Venue.present_directory_letters.first
    if @letter != params[:letter]
      redirect_to directory_venues_path(:letter => @letter)
    else
      if @letter =~ /^[a-zA-Z]/
        @venues = @venues.where("name LIKE?","#{@letter}%")
      else
        @letter = '#'
        @venues = @venues.where("name REGEXP '^[^a-zA-Z]'")
      end
      render :template => 'organisations/directory'
    end
  end

  
  def index
    @venues = Venue.order("created_at DESC")
    render :template => 'organisations/directory'
  end
  
  def latest
    @venues = Venue.order("created_at DESC").limit(10)
    render :template => 'organisations/directory'
  end
  
  def search
    @query = strip_tags(params[:q]).to_s.strip
    if @query.present?
      @venues = Venue.search(@query)
    else
      @venues = []
    end
    render :template => 'organisations/directory'
  end
  
  
  def new
    promoter = Promoter.find(params[:promoter_id])
    promoter.build_social_links
    venue.attributes = {:promoter_id => promoter.id, :region => promoter.region}
  end
  
  def show
    @dates =  TourDate.where(:booked => true,).where('date > ?', Date.today).where(:venue_id => params[:id])   
  end
  
  def update
    if venue.save
      flash_notice(venue)
      redirect_to(venue)
    else
      render :action => 'edit'
    end
  end
  
end