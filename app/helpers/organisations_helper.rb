module OrganisationsHelper

  def internationalize_phone_number(phone_number)
    phone_number.sub(/\s*0/, "+44 (0)")
  end
  
  def render_address(organisation,options={})
    options.reverse_merge!(:br => true)
    @render_address ||= begin
      rows = [organisation.address1, organisation.address2] << [organisation.city, organisation.postcode].select(&:present?).map(&:strip).join(', ')
      rows.select(&:present?).join(options[:br] ? "<br>" : ', ').html_safe
    end
  end
  
  def directory_title
    if controller_name.promoters?
      title = "Organisations"
    elsif controller_name.users?
      title = "People"
    else
      title = controller_name.titleize
    end
    if @tag
      title += " with " + @tag_context +  " \"" + @tag + "\""
      title.gsub!('_',' ')
      title.gsub!('-',' ') 
    end
    title
  end
  
end