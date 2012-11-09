module DiaryHelper

  def link_to_next_month(month=Date.today.month, year=Date.today.year, tags, start_date, end_date)
    next_month = Date.parse("#{month}/#{year}") + 1.month
    link_to ">", diary_path(:month => next_month.month, :year => next_month.year, :tags => tags, :start_date => start_date, :end_date => end_date)
  end

  def link_to_previous_month(month=Date.today.month, year=Date.today.year, tags, start_date, end_date)
    previous_month = Date.parse("#{month}/#{year}") - 1.month
    link_to "<", diary_path(:month => previous_month.month, :year => previous_month.year, :tags => tags, :start_date => start_date, :end_date => end_date)
  end

end