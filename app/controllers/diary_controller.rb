class DiaryController < ApplicationController
  authorize_resource :class => false

  def index

    @tags = [*params[:tags]]
    @start_date = params[:start_date]
    @end_date = params[:end_date]
    @month = params[:month] || Date.today.month
    @year = params[:year] || Date.today.year

    @all_tags = Tour.genre_counts.order(:name)

    @dates =  TourDate.future.where('MONTH(date) = :month AND YEAR(date) = :year', :month => @month, :year => @year)

    if (@tags).present?
      tour_ids = Tour.tagged_with(@tags).collect(&:id)
      @dates = @dates.where(:tour_id => tour_ids)
    end
    if @start_date.present?
      tour_ids = Tour.where("end_on > ?", Date.parse(@start_date))
      @dates = @dates.where(:tour_id => tour_ids)
    end
    if @end_date.present?
      @dates = @dates.where("start_on < ?", Date.parse(@end_date))
    end
  end

end