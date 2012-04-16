class VenuesController < ApplicationController

  expose(:venue)
  
  def create
    if venue.save
      flash[:notice] = 'Created new venue'
      redirect_to(venue)
    else
      render :action => 'new'
    end
  end
  
  def destroy
    venue.destroy
    flash[:notice] = "Deleted venue #{venue}"
    redirect_to(venue.promoter)
  end

  def edit;end
  
  def new
    promoter = Promoter.find(params[:promoter_id])
    venue.attributes = {:promoter_id => promoter.id, :region => promoter.region}
  end
  
  def show;end
  
  def update
    if venue.save
      flash[:notice] = 'Updated venue'
      redirect_to(venue)
    else
      render :action => 'edit'
    end
  end
  
end