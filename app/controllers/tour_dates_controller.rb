class TourDatesController < ApplicationController
  load_and_authorize_resource
  
  expose(:tour_dates) {TourDate.order('date')}
  expose(:tour_date)
  
  def create
    if tour_date.save
      flash[:notice] = "Thanks for adding a date. This will be reviewed shortly by the website administrator before appearing in the diary."
      redirect_to diary_path
    else
      flash_notice = tour_date
      redirect_to diary_path 
    end
  end
  
  def needs_approval
    @pending_dates = TourDate.where('needs_approval = 1')
  end
  
  def approve_dates
    if params &&  params['date_id']
      params['date_id'].each do |date_id|
        TourDate.find(date_id).confirm_booking
      end
      flash[:notice] = "Date(s) approved and added to the diary."  
    else
      flash[:error] = "Please select the dates you wish to approve."    
    end  
    redirect_to needs_approval_tour_dates_path
  end
  

end