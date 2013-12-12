$ ->
  $(document).on "click", ".icon-edit", ->
    id = $(this).data().id
    $("#edit_project_user_#{id}").show()
    $("#member-#{id}-roles").hide()

  $(document).on "click", ".close_form", ->
    id = $(this).data().id
    $(this).closest("form").hide()
    $("#member-#{id}-roles").show()

  $(document).on "click", ".add_member", ->
    members = $("input[name*='member[]']:checked").map(->
      $(this).val()
    ).get()
    roles = $("input[name*='role[]']:checked").map(->
      $(this).val()
    ).get()
    project = {}
    project["id"] = $("#project_id").val()
    project["start_date"] = $("#start_date").val()
    project["due_date"] = $("#due_date").val()
    i = 0
    project["project_users_attributes"] = []
    project_user_attr = {}
    while i < members.length
      project["project_users_attributes"].push({'user_id': members[i], 'project_user_roles_attributes': get_role_attr(roles),'join_date': $("#start_date").val(), 'due_date': $("#due_date").val()})
      i++
    $.ajax "/projects/assign_members",
        type: "POST",
        data: {project:project}
        success: (data)->
          window.location.reload()

  get_role_attr = (roles)->
    data_return = []
    if roles.length > 0
      i = 0
      while i < roles.length
        data_return.push({"project_role_id": roles[i]})
        i++
    data_return

  $(document).on "input", "#principal_search", ->
    keyword = $.trim($(this).val())
    if keyword != ""
      keyword = keyword.toLowerCase();
      $(".user_name").each ->
        if $(this).data().id.indexOf(keyword) >= 0
          $(this).show()
        else
          $(this).hide()
    else
      $("div.user_name").show()




