class ToursController < ApplicationController
  
  expose(:tour)  
  expose(:company) {params[:company_id] ? Company.find(params[:company_id]) : nil}
  expose(:tours) {company.try(:tours) || Tour.all}
  
  def create
    if tour.save
      flash_notice(tour)      
      redirect_to tour
    else
      render :action => "new"
    end
  end
  
  def update
    if tour.save
      flash_notice(tour)
      redirect_to tour
    else
      render :action => "edit"
    end
  end
  
  def destroy
    tour.destroy
    flash_notice(tour)
    redirect_to(tour.company)
  end
  
end