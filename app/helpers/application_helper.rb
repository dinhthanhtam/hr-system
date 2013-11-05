module ApplicationHelper
  def h2_label
    I18n.t "views.pages.#{controller_name.singularize}.#{action_name}"
  end
end
