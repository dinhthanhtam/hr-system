module ApplicationHelper
  def h2_label
    I18n.t "views.pages.#{controller_name.singularize}.#{action_name}"
  end

  def cweek_to_date cweek, year
    week_begin = Date.commercial(year, cweek, 1)
    week_end = Date.commercial(year, cweek, 7)
    "#{week_begin} ~ #{week_end}"
  end

  def include_not_select
    [[t(:not_select, scope: [:views, :labels])]]
  end

  def puts_name group, count
    result = ""
    if group.children.empty?
      result += "<li class='item_left_menu' style='margin-top: 10px; margin-left:#{count.to_i * 15}px'><a id='group_#{ group.id }' href='#'>#{ group.name }</a></li>"
      group.teams.each do |team|
        result += "<li class='item_left_menu' style='margin-top: 10px; margin-left:#{(count.to_i + 1) * 15}px'><a id='team_#{ team.id }' href='#'>#{ team.name }</a></li>"
      end
      return result
    else
      result = "<li class='item_left_menu' style='margin-top: 10px; margin-left:#{count.to_i * 15}px'><a id='group_#{ group.id }' href='#'>#{ group.name }</a></li>"
      count += 1
      group.teams.each do |team|
        result += "<li class='item_left_menu' style='margin-top: 10px; margin-left:#{count.to_i * 15}px'><a id='team_#{ team.id }' href='#'>#{ team.name }</a></li>"
      end
      group.children.each do |child|
        result += puts_name(child, count)
      end
      return result
    end
  end
end
