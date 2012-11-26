class TourDatesController < ApplicationController
  load_and_authorize_resource
  
  expose(:tour_dates) {TourDate.order('date')}
  expose(:tour_date)
  
  def create
    if tour_date.save
      flash[:notice] = "Thanks for adding a date. This will be reviewed shortly by the website administrator before appearing in the diary."
      redirect_to diary_path( tour_date, {:month => tour_date.date.month, :year => tour_date.date.year})
    else
      flash_notice = tour_date
      redirect_to(diary_path)
    end
  end
  
end