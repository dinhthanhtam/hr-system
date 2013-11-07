module ApplicationHelper
  def h2_label
    I18n.t "views.pages.#{controller_name.singularize}.#{action_name}"
  end

  def cweek_to_date cweek, year
    week_begin = Date.commercial(year, cweek, 1)
    week_end = Date.commercial(year, cweek, 7)
    "#{week_begin} ~ #{week_end}"
  end
end
