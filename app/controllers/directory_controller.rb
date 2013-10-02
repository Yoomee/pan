class DirectoryController < ApplicationController
  authorize_resource :class => false
  before_filter :set_up_queries_and_classes
  
  def directory

    search_params = {:classes => @search_classes, :match_mode => :extended, :order => :name_sort, :sort_mode => :asc, :per_page => 40, :page => params[:page]}
    
    if @search_classes.empty?
      @everything = []
    elsif @query.present? && @conditions.present?
      @everything = ThinkingSphinx.search(@query, search_params.merge(:conditions => @conditions))
    elsif @query.present?
      @everything = ThinkingSphinx.search(@query, search_params)
    elsif @conditions.present?
      # If we had a newer version of sphinx we could do this for first letter of first word
      # @everything = ThinkingSphinx.search("@name[1] ^?", @letter, :conditions => @conditions, :classes => @search_classes, :match_mode => :extended, :order => :name_sort, :sort_mode => :asc, :per_page => 40)
        @everything = ThinkingSphinx.search(search_params.merge(:conditions => @conditions))
    elsif @search_classes.present?
      @everything = ThinkingSphinx.search(search_params)
    else
      @everything = []
    end


    # @everything = ThinkingSphinx.search(@query, :conditions => @conditions, :classes => @search_classes, :match_mode => :extended, :order => :name_sort, :sort_mode => :asc, :per_page => 40, :page => params[:page])


    render :template => 'organisations/directory'
  end
  
  def search
    @query = strip_tags(params[:q]).to_s.strip
    
    if @query.present?
      if @conditions.present?
        @everything = ThinkingSphinx.search(@query, :conditions => @conditions, :classes => @search_classes, :match_mode => :extended, :order => :name_sort, :sort_mode => :asc, :per_page => 40)
      else
        @everything = ThinkingSphinx.search(@query, :match_mode => :extended, :classes => @search_classes, :order => :name_sort, :sort_mode => :asc, :per_page => 40)
      end
    else
      @everything = []
    end
    render :template => 'organisations/directory'
  end
  

  private
  def set_up_queries_and_classes
    @collection = Collection.find_by_id(params[:collection]).to_s.parameterize
    @region = params[:region]
    @tags = [*params[:tags]]
    @type = params[:type]
    @query = strip_tags(params[:q]).to_s.strip

    @search_classes = [Performer, Promoter, Tour, Venue, User]
    @search_classes &= [Tour] if @collection.present?
    @search_classes &= [Promoter, Tour, Venue] if @region.present?
    @search_classes &= [Performer, Promoter, Tour] if @tags.present?
    @search_classes &= [params[:type].to_s.capitalize.constantize] if @type.present?
    
    @search_tags = @tags.join(" & ").gsub(/-/, ' ')
    
    @conditions = {}.tap do |hash|
      hash[:collection] = @collection.gsub(/-/, ' ') if @collection.present?
      hash[:genres] = @search_tags if @search_tags.present?
      hash[:region] = Pan::REGIONS[@region] if @region.present?
      # hash[:type] = @type if @type.present?
    end
  end

end