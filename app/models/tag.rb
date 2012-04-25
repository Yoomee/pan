class Tag < ActsAsTaggableOn::Tag
  
  include YmTags::Tag
  
  scope :for_context, lambda {|context| joins(:taggings).where(["taggings.context = ?", context]).group('tags.id')}
  scope :genres, for_context('genres')
  scope :art_forms, for_context('art_forms')
  scope :funders, for_context('funders')
  scope :work_scales, for_context('work_scales')
  
end
