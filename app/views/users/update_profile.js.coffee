<% unless @success %>
  $(".update_errors").remove()
  $("#" + "<%= @id %>").before("<%= escape_javascript(render partial: 'update_errors', locals: {object: @user}) %>")
<% else %>
  $(".data_settings").hide()
  display_settings = $("#" + "<%= @id %>").closest("form").siblings(".display_settings")
  display_settings.html("<%= @user.send(@id) %>") if ("<%= @id %>" != "password_confirmation")
  display_settings.show()
<% end %>