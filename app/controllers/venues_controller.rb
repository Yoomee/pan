class VenuesController < ApplicationController

  expose(:venue)
  expose(:venues) {Venue.all}
  expose(:posts) {venue.posts.page(params[:page])}
  
  def create
    if venue.save
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

  def edit;end
  
  def location;end
   
  def index
  end
  
  def new
    promoter = Promoter.find(params[:promoter_id])
    venue.attributes = {:promoter_id => promoter.id, :region => promoter.region}
  end
  
  def show;end
  
  def update
    if venue.save
      flash_notice(venue)
      redirect_to(venue)
    else
      render :action => 'edit'
    end
  end
  
end