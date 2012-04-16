module PromotersHelper

  def internationalize_phone_number(phone_number)
    phone_number.sub(/\s*0/, "+44 (0)")
  end
  
  def render_promoter_address(promoter)
    @render_promoter_address ||= begin
      rows = [promoter.address1, promoter.address2] << [promoter.address3, promoter.address4].select(&:present?).map(&:strip).join(', ')
      rows.select(&:present?).join("<br>").html_safe
    end
  end
  
end