class ReviewsController < ApplicationController
  
  load_and_authorize_resource
  
  before_filter :get_tour, :get_performer
  
  def create
    @review.user = current_user
    @review.tour = @tour    
    @review.performer = @performer
    if @review.save
      flash_notice(@review)
      redirect_to @tour ? tour_reviews_path : performer_reviews_path
    else
      render :action => "new"
    end   
  end
  
  def index
    @reviews = (@tour || @performer).reviews
  end
  
  private
  def get_performer
    @performer = Performer.find_by_id(params[:performer_id])
  end
  
  def get_tour
    @tour = Tour.find_by_id(params[:tour_id])
  end
  
end