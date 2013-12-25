$ ->
  $(document).on "click", ".icon-edit", ->
    id = $(this).data().id
    $("#edit_project_user_#{id}").show()
    $("#member-#{id}-roles").hide()

  $(document).on "click", ".close_form", ->
    id = $(this).data().id
    $(this).closest("form").hide()
    $("#member-#{id}-roles").show()

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

  $(".project_user_check_box").click ->
    $that = $(this)
    if $that.is(":checked")
      $(".project_user_role input:checked").each ->
        class_name = $(this).attr("class")
        $that.closest(".user_name").find("." + class_name).prop("checked", true)
    else
      $that.closest(".user_name").find(".project_role :checkbox").prop("checked", false)

  $(".project_user_role :checkbox").click ->
    class_name = $(this).attr("class")
    if $(this).is(":checked")
      $(".project_user input:checked").each ->
        $(this).closest(".user_name").find("." + class_name).prop("checked", true)
    else
      $(".project_user input:checked").each ->
        $(this).closest(".user_name").find("." + class_name).prop("checked", false)
