class DiaryController < ApplicationController
  authorize_resource :class => false

  def index

    @tags = [*params[:tags]]
    @start_date = params[:start_date]
    @end_date = params[:end_date]
    @tour_id = params[:tour_id]
    @organisation_id = params[:organisation_id]
    
    if @tour_id.present?
      @month = params[:month]
      @year = params[:year]
    elsif @organisation_id.present?
      @month = params[:month]
      @year = params[:year]
    else
      @month = params[:month] || Date.today.month
      @year = params[:year] || Date.today.year
    end

    @all_tags = Tour.genre_counts.order(:name)

    @dates =  TourDate.where(:booked => true).order(:date)

    if @month.present? && @year.present?
      @dates = @dates.where('MONTH(date) = :month AND YEAR(date) = :year', :month => @month, :year => @year)
    end
    if @tags.present?
      tour_ids = Tour.tagged_with(@tags).collect(&:id)
      @dates = @dates.where(:tour_id => tour_ids)
    end
    if @start_date.present?
      @dates = @dates.where("date > ?", Date.parse(@start_date))
    end
    if @end_date.present?
      @dates = @dates.where("date < ?", Date.parse(@end_date))
    end
    if @tour_id.present?
      @dates = @dates.where(:tour_id => @tour_id)
    end
    if @organisation_id.present?
      @dates = @dates.where(:venue_id => Promoter.find(@organisation_id).venues)
    end

  end

end