class Tag < ActsAsTaggableOn::Tag
  
  include YmTags::Tag
  
  scope :contexts, lambda {|contexts| joins(:taggings).where(["taggings.context IN (?)", [*contexts]]).group('tags.id')}
  scope :context_begins_with, lambda {|prefix| joins(:taggings).where(["taggings.context LIKE ?", "#{prefix}%"]).group('tags.id')}
  
  scope :art_forms, context_begins_with('art_form')
  scope :funders, contexts('funders')
  scope :genres, context_begins_with('genre')
  scope :resource_tags, contexts('resource_tags')
  scope :skills, context_begins_with('skills')
  scope :work_scales, contexts('work_scales')
  
end
