class TourDatesController < ApplicationController
  load_and_authorize_resource
  
  expose(:tour_dates) {TourDate.order('date')}
  expose(:tour_date)
  
  def create
    tour_date.needs_approval = true
    tour_date.user_id = current_user.id
    if tour_date.save
      UserMailer.approval_needed.deliver
      flash[:notice] = "Thanks for adding a date. This will be reviewed shortly by the website administrator before appearing in the diary."
      redirect_to diary_path
    else
      flash[:notice] = "The tour date could not be saved: " << tour_date.errors.full_messages.join('/')
      redirect_to diary_path 
    end
  end

  def destroy
    if tour_date.update_attribute(:removed_at, Time.now)
      flash[:notice] = "Date successfully deleted from the diary."
    else
      flash[:notice] = "The date could not be removed from the diary."
    end
    redirect_to diary_path
  end
  
  def needs_approval
    @tour_dates = TourDate.order('needs_approval DESC, created_at DESC').where('tour_id IS NOT NULL').paginate(:per_page => 20, :page => params[:page])
  end

  def update
    tour_date.attributes = { :needs_approval => true, :booked => false }
    if tour_date.save
      flash[:notice] = "Thanks for updating a date. This will be reviewed shortly by the website administrator before appearing in the diary."
      redirect_to diary_path
    else
      flash_notice = tour_date
      redirect_to diary_path 
    end
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