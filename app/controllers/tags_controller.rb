class TagsController < ApplicationController
  
  include YmTags::TagsController
  
  expose(:posts) {Post.tagged_with(current_tag.name).page(params[:page])}
  
  autocomplete :genre, :name, :full => true, :class_name => 'Tag', :scopes => :genres
  autocomplete :art_form, :name, :full => true, :class_name => 'Tag', :scopes => :art_forms
  autocomplete :funder, :name, :full => true, :class_name => 'Tag', :scopes => :funders
  
end