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
      hash[:genres] = @tags.join(' | ') if @tags.present?
      hash[:region] = @region if @region.present?
    end

    @withs = {}
    @withs[:end_on] = @start_date.present? ? Time.parse(@start_date)..10.years.from_now : Time.now..10.years.from_now
    @withs[:start_on] = 10.years.ago..Time.parse(@end_date) if @end_date.present?

    

    @tours = Tour.search(@query, :conditions => @conditions, :with => @withs, :match_mode => :extended, :order => @sort, :per_page => 10, :page => params[:page])

  end

  def set_view
    session[:view] = %w{list block}.include?(params[:view]) ? params[:view] : 'list'
    redirect_to(params[:return_to])
  end

end
