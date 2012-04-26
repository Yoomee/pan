module TagsHelper
  
  def tag_list_options(context, resource, tags = nil)
    tags ||= Tag.contexts(context)
    (tags.collect(&:name) + resource.send("#{context.to_s.singularize}_list")).uniq.sort
  end
  
end