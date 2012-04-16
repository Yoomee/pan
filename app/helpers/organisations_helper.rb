module OrganisationsHelper

  def internationalize_phone_number(phone_number)
    phone_number.sub(/\s*0/, "+44 (0)")
  end
  
  def render_address(organisation)
    @render_address ||= begin
      rows = [organisation.address1, organisation.address2] << [organisation.address3, organisation.address4].select(&:present?).map(&:strip).join(', ')
      rows.select(&:present?).join("<br>").html_safe
    end
  end
  
end