class ToursController < ApplicationController

  load_and_authorize_resource
  
  expose(:tour)  
  expose(:performer) {params[:performer_id] ? Performer.find(params[:performer_id]) : nil}
  expose(:tours) {performer.try(:tours) || Tour.all}
  
  def create
    if tour.save
      flash_notice(tour)      
      redirect_to tour
    else
      render :action => "new"
    end
  end
  
  def bookings
  end
  
  def index
  end
  
  def new
    @performer = Performer.find(params[:performer_id])
    @tour = @performer.tours.build(:genre_list => @performer.genre_list)
  end
  
  def update
    if tour.save
      flash_notice(tour)
      redirect_to tour
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