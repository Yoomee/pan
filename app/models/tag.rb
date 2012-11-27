class Tag < ActsAsTaggableOn::Tag
  
  include YmTags::Tag

  scope :context_begins_with, lambda {|prefix| joins(:taggings).where(["taggings.context LIKE ?", "#{prefix}%"]).group('tags.id')}
  
  scope :art_forms, context_begins_with('art_form')
  scope :collections, contexts('collections')
  scope :funders, contexts('funders')
  scope :genres, context_begins_with('genre')
  scope :resource_tags, contexts('resource_tags')
  scope :skills, context_begins_with('skills')
  scope :work_scales, contexts('work_scales')
  
  scope :tags, contexts('tags')
  scope :categories, contexts('categories')
  
  
  scope :most_talked_about, most_used.where("taggings.taggable_type = 'Post'") 
  
end
