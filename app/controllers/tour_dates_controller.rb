class TourDatesController < ApplicationController
  load_and_authorize_resource
  
  expose(:tour_dates) {TourDate.order('date')}
  expose(:tour_date)
  
  def create
    if tour_date.save
      flash[:notice] = "Date added to diary"
      redirect_to(diary_path)
    else
      flash[:notice] = "Something went wrong"
      redirect_to(diary_path)
    end
  end
  
end