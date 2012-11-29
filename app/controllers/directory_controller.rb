class DirectoryController < ApplicationController
  authorize_resource :class => false
  before_filter :set_up_queries_and_classes
  
  def directory
    @letter = params[:letter].to_s.first.upcase.presence || "A"
    
    if @letter != params[:letter]
      redirect_to directory_path(:letter => @letter)
    else
      if @letter =~ /^[a-zA-Z]/
        if @conditions.present?
          @everything = ThinkingSphinx.search("@name ^?", @letter, :conditions => @conditions, :classes => @search_classes, :match_mode => :extended, :order => :name_sort, :sort_mode => :asc, :per_page => 200)
        else
          @everything = ThinkingSphinx.search("@name ^?", @letter, :classes => @search_classes, :match_mode => :extended, :order => :name_sort, :sort_mode => :asc, :per_page => 200)
        end
      elsif @letter = "+"
        if @conditions.present?
          @everything = ThinkingSphinx.search(:conditions => @conditions, :classes => @search_classes, :match_mode => :extended, :order => :name_sort, :sort_mode => :asc, :per_page => 200)
        else
          @everything = ThinkingSphinx.search(:classes => @search_classes, :match_mode => :extended, :order => :name_sort, :sort_mode => :asc, :per_page => 200)
        end
      else
        @letter = '#'
        if @conditions.present?
          @everything = ThinkingSphinx.search("@name ^1 | ^2 | ^3 | ^4 | ^5 | ^6 | ^7 | ^8 | ^9 | ^0", :conditions => @conditions, :match_mode => :extended, :classes  => @search_classes, :order => :name_sort, :sort_mode => :asc, :per_page => 200)
        else
          @everything = ThinkingSphinx.search("@name ^1 | ^2 | ^3 | ^4 | ^5 | ^6 | ^7 | ^8 | ^9 | ^0", :match_mode => :extended, :classes  => @search_classes, :order => :name_sort, :sort_mode => :asc, :per_page => 200)
        end
      end
      render :template => 'organisations/directory'
    end
  end
  
  def search
    @query = strip_tags(params[:q]).to_s.strip
    
    if @query.present?
      if @conditions.present?
        @everything = ThinkingSphinx.search(@query, :conditions => @conditions, :classes => @search_classes, :match_mode => :extended, :order => :name_sort, :sort_mode => :asc, :per_page => 200)
      else
        @everything = ThinkingSphinx.search(@query, :match_mode => :extended, :classes => @search_classes, :order => :name_sort, :sort_mode => :asc, :per_page => 200)
      end
    else
      @everything = []
    end
    render :template => 'organisations/directory'
  end
  

  private
  def set_up_queries_and_classes
    @collection = params[:collection]
    @region = params[:region]
    @tags = [*params[:tags]]
    @type = params[:type]

    @search_classes = [Performer, Promoter, Tour, Venue, User]
    @search_classes &&= [Tour] if @collection.present?
    @search_classes &&= [Promoter, Tour, Venue] if @region.present?
    @search_classes &&= [Performer, Promoter, Tour] if @tags.present?
    @search_classes &&= [params[:type].to_s.capitalize.constantize] if @type.present?
    
    @search_tags = @tags.join(" & ").gsub(/-/, ' ')
    
    @conditions = {}.tap do |hash|
      hash[:collection] = @collection.gsub(/-/, ' ') if @collection.present?
      hash[:genres] = @search_tags if @search_tags.present?
      hash[:region] = @region if @region.present?
    end
  end

end