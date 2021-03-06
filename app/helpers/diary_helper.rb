module DiaryHelper

  def link_to_next_month(month=Date.today.month, year=Date.today.year)
    next_month = Date.parse("#{month}/#{year}") + 1.month
    param_options = set_params_options
    param_options.merge!({:month => next_month.month, :year => next_month.year})

    link_to "&rsaquo;".html_safe, diary_path(param_options), :class => "next-month"
  end

  def link_to_previous_month(month=Date.today.month, year=Date.today.year)
    previous_month = Date.parse("#{month}/#{year}") - 1.month
    param_options = set_params_options
    param_options.merge!({:month => previous_month.month, :year => previous_month.year})
    link_to "&lsaquo;".html_safe, diary_path(param_options), :class => "previous-month"
  end

  def set_params_options
    {}.tap do |hash|
      hash[:collection] = params[:collection] if params[:collection].present?
      hash[:region] = params[:region] if params[:region].present?
      hash[:tags] = params[:tags] if params[:tags].present?
      hash[:type] = params[:type] if params[:type].present?
    end  
  end
  
  def format_time(time_str)
    return "" if time_str.nil?
    hours = time_str.split(":")[0].to_i
    minutes = time_str.split(":")[1].to_i
    if hours>12 
      hours = hours-12 
      period = "pm"
    else
      period = "am"
    end  
    if minutes == 0
      "#{hours} #{period}"
    else
      "#{hours}:#{minutes} #{period}"
    end
  end
  

end