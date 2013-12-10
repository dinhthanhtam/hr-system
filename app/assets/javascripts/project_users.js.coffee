$ ->
  $(document).on "click", ".icon-edit", ->
    id = $(this).data().id
    $("#edit_project_user_#{id}").show()
    $("#member-#{id}-roles").hide()

  $(document).on "click", ".close_form", ->
    id = $(this).data().id
    $(this).closest("form").hide()
    $("#member-#{id}-roles").show()
