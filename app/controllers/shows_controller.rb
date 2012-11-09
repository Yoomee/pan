class ShowsController < ApplicationController
  authorize_resource :class => false

  def index
    @tags = [*params[:tags]]
    @start_date = params[:start_date]
    @end_date = params[:end_date]

    @tours = Tour.where("end_on > ?", Date.today).order(:start_on)
    @tour_tags = @tours.genre_counts.order(:name)

    if (@tags).present?
      @tours = @tours.tagged_with(@tags)
    end
    if @start_date.present?
      @tours = @tours.where("end_on > ?", Date.parse(@start_date))
    end
    if @end_date.present?
      @tours = @tours.where("start_on < ?", Date.parse(@end_date))
    end

  end

  def set_view
    session[:view] = %w{list block}.include?(params[:view]) ? params[:view] : 'list'
    redirect_to(params[:return_to])
  end

end