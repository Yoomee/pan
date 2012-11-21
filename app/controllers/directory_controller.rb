class DirectoryController < ApplicationController
  authorize_resource :class => false

  def directory
    @letter = params[:letter].to_s.first.upcase.presence || "A"
    
    search_classes = params[:type].present? ? [params[:type].to_s.capitalize.constantize] : [Performer, Promoter, Tour, Venue, User]
    
    
    if @letter != params[:letter]
      redirect_to directory_path(:letter => @letter)
    else
      if @letter =~ /^[a-zA-Z]/
        @everything = ThinkingSphinx.search("@name ^?", @letter, :match_mode => :extended, :classes => search_classes, :order => :name_sort, :sort_mode => :asc)
      else
        @letter = '#'
        @everything = ThinkingSphinx.search("@name ^1 | ^2 | ^3 | ^4 | ^5 | ^6 | ^7 | ^8 | ^9 | ^0", :match_mode => :extended, :classes  => search_classes, :order => :name_sort, :sort_mode => :asc)
      end
      render :template => 'organisations/directory'
    end
  end
  
  def search
    @query = strip_tags(params[:q]).to_s.strip
    search_classes = params[:type].present? ? [params[:type].to_s.capitalize.constantize] : [Performer, Promoter, Tour, Venue, User]
    
    if @query.present?
      @everything = ThinkingSphinx.search(@query, :match_mode => :extended, :classes => search_classes, :order => :name_sort, :sort_mode => :asc)
    else
      @everything = []
    end
    render :template => 'organisations/directory'
  end

end