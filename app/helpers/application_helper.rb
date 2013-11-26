module ApplicationHelper
  def h2_label
    I18n.t "views.pages.#{controller_name.singularize}.#{action_name}"
  end

  def include_not_select
    [[t(:not_select, scope: [:views, :labels]), nil]]
  end

  def puts_name group, count
    result = ""
    if group.children.empty?
      result += "<tr><th class='item_left_menu'><a id='group_#{ group.id }' href='#'>#{ group.name }</a></th></tr>"
      group.teams.each do |team|
        result += "<tr><td class='item_left_menu'><a id='team_#{ team.id }' href='#'>#{ team.name }</a></td></tr>"
      end
      return result
    else
      result = "<tr><th class='item_left_menu'><a id='group_#{ group.id }' href='#'>#{ group.name }</a></th></tr>"
      count += 1
      group.teams.each do |team|
        result += "<tr><td class='item_left_menu'><a id='team_#{ team.id }' href='#'>#{ team.name }</a></td></tr>"
      end
      group.children.each do |child|
        result += puts_name(child, count)
      end
      return result
    end
  end
end
