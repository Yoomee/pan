class ShowsController < ApplicationController
  authorize_resource :class => false

  def index
    @tags = [*params[:tags]]
    @start_date = params[:start_date]
    @end_date = params[:end_date]
    @collection = params[:collection]
    @region = params[:region]
    @sort = params[:sort].try(:to_sym).presence || :start_on
    @query = params[:q]


    @all_tags = Tour.genre_counts.order(:name)

    @conditions = {}.tap do |hash|
      hash[:collection] = @collection.gsub(/-/, ' ') if @collection.present?
      hash[:genres] = @tags if @tags.present?
      hash[:region] = @region if @region.present?
    end

    @withs = {}.tap do |hash|
      hash[:end_on] = Time.parse(@start_date)..10.years.from_now if @start_date.present?
      hash[:start_on] = Time.now..Time.parse(@end_date) if @end_date.present?
    end

    @tours = Tour.search(@query, :conditions => @conditions, :with => @withs, :match_mode => :any, :order => @sort)

  end

  def set_view
    session[:view] = %w{list block}.include?(params[:view]) ? params[:view] : 'list'
    redirect_to(params[:return_to])
  end

end
