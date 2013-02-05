class ToursController < ApplicationController

  load_and_authorize_resource
  
  expose(:tour)  
  expose(:performer) {params[:performer_id] ? Performer.find(params[:performer_id]) : nil}
  expose(:tours) {performer.try(:tours) || Tour.scoped}
  
  def create
    @tour = Tour.new(params[:tour])
    if @tour.save
      current_user.record_activity!(@tour)
      flash[:notice] = "Created a new show"
      redirect_to @tour
    else
      render :action => "new"
    end
  end
  
  def bookings
  end
  
  def edit
    @tour = Tour.find(params[:id])
  end
  
  def index
    @tag, @tag_context = params[:tag], params[:tag_context]
  end
  
  def new
    @performer = Performer.find(params[:performer_id])
    @tour = @performer.tours.build(:genre_list => @performer.genre_list)
  end
  
  def rating  
    @tours = Tour.order_by_ratings
  end
  
  def show
    @available_dates = tour.dates
  end
  
  def update
    @tour = Tour.find(params[:id])
    if @tour.update_attributes(params[:tour])
      flash[:notice] = "Updated show details"
      redirect_to @tour
    else
      render :action => request.referrer =~ /\/bookings/ ? 'bookings' : 'edit'
    end
  end
  
  def destroy
    tour.destroy
    flash_notice(tour)
    redirect_to(tour.performer)
  end
  
end