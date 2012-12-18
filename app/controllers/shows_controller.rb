class ShowsController < ApplicationController
  authorize_resource :class => false

  def index
    @tags = [*params[:tags]]
    @start_date = params[:start_date]
    @end_date = params[:end_date]
    @collection = params[:collection]
    @region = params[:region]
    @sort = params[:sort]

    @all_tags = Tour.genre_counts.order(:name)
    @tours = Tour.where("end_on > ?", Date.today)#.order(:name)

    if (@tags).present?
      @tours = @tours.tagged_with(@tags)
    end
    if @start_date.present?
      @tours = @tours.where("end_on > ?", Date.parse(@start_date))
    end
    if @end_date.present?
      @tours = @tours.where("start_on < ?", Date.parse(@end_date))
    end
    if @region.present?
      @tours = @tours.where('tours.id IN (SELECT tour_dates.tour_id FROM tour_dates WHERE (tour_dates.id IN (SELECT id FROM venues WHERE venues.region = ?)))', @region)
    end
    if @sort.present?
      @tours = case @sort
      when "title"
        @tours.order(:name)
      when "performer"
        @tours.joins(:performer).order('performers.name')
      when "start-date"
        @tours.order(:start_on)
      when "date-added"
        @tours.order(:created_at)
      end
    end
    if @collection.present?
      Collection.all.each do |collection|
        if collection.name.parameterize == @collection
          @tours = @tours.joins(:collections).collect{ |tour| tour if tour.collections.include?(collection) }.compact.uniq
        end
      end
    end
  end

  def set_view
    session[:view] = %w{list block}.include?(params[:view]) ? params[:view] : 'list'
    redirect_to(params[:return_to])
  end

end
