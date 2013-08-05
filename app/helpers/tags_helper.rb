module TagsHelper
  
  def comma_list_tags(resource, tag_context)
    out = []
    resource.send("#{tag_context.to_s.singularize}_list").each do |tag_name|
      # out << tag_context == :skills ? tag_name.to_s.titleize.humanize : link_to_tag_in_context(tag_name, resource.class.to_s.underscore.pluralize, tag_context)
      if tag_context == :skills
        out << tag_name.to_s.titleize.humanize
      else
        out << link_to_tag_in_context(tag_name, resource.class.to_s.underscore.pluralize, tag_context)
      end
    end
    out.join(', ').html_safe
  end
  
  def list_tags(resource, tag_context)
    out = ""
    resource.send("#{tag_context.to_s.singularize}_list").each do |tag_name|
      out += content_tag(:li, link_to_tag_in_context(tag_name, resource.class.to_s.underscore.pluralize, tag_context))
    end
    content_tag(:ul, out.html_safe, :class => "unstyled")
  end

  def link_to_tag_in_context(tag_name, resource_controller, tag_context, options = {})
    link_to(tag_name.to_s.titleize.humanize, send("tag_#{resource_controller}_path", tag_context.to_s, tag_name), options)
  end  
end