class TagsController < ApplicationController
  
  include YmTags::TagsController
  expose(:posts) {Post.tagged_with(current_tag.name).page(params[:page])}
  expose(:tag_contexts) {Tag.joins(:taggings).order(:name).select("taggings.context AS context,tags.*").group("taggings.context,tags.id").group_by(&:context).sort_by(&:first)}
  
  def index
  end
  
end