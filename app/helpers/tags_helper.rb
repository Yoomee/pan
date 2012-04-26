module TagsHelper
  
  def tag_list_options(context, resource)
    (Tag.for_context(context).collect(&:name) + resource.send("#{context.to_s.singularize}_list")).uniq.sort
  end
  
end