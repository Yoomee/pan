class ReviewsController < ApplicationController
  
  load_and_authorize_resource
  
  before_filter :get_performer
  
  def create
    @review.user = current_user
    @review.performer = @performer
    
    if @review.save
      flash_notice(@review)
      redirect_to performer_reviews_path
    else
      render :action => "new"
    end   
  end
  
  def index
    @reviews = @performer.reviews
  end
  
  private
  def get_performer
    @performer = Performer.find(params[:performer_id])
  end
end