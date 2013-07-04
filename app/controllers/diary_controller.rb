class DiaryController < ApplicationController
  authorize_resource :class => false

  def index

    @collection = params[:collection]
    @end_date = params[:end_date]
    @organisation_id = params[:organisation_id]
    @region = params[:region]
    @start_date = params[:start_date]
    @tags = [*params[:tags]]
    @tour_id = params[:tour_id]
    @venue_id = params[:venue_id]

    @all_tags = Tour.genre_counts.order(:name)

    @dates =  TourDate.approved.where('date > ?', Date.today)

    if @tags.present?
      tour_ids = Tour.tagged_with(@tags).collect(&:id)
      @dates = @dates.where(:tour_id => tour_ids)
    end
    if @collection.present?
      Collection.all.each do |collection|
        if collection.name.parameterize == @collection
          tour_id = Tour.joins(:collections).collect{ |tour| tour.id if tour.collections.include?(collection) }
          @dates = @dates.where(:tour_id => tour_id)
        end
      end
    end
    if @region.present?
      @dates = @dates.where('venue_id IN (SELECT id FROM venues WHERE venues.region = ?)', @region)
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
    if @venue_id.present?
      @dates = @dates.where(:venue_id => @venue_id)
    end

    @dates = @dates.order(:date).paginate(:page => params[:page], :per_page => 25)

  end

end