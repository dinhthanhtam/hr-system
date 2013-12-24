$ ->
  $("#period").change ->
    $("#checkpoint_periods").submit()
   
  $(document).on "click", "#leader_select", ->
    if $(this).val()
      group_id = $(this).val()
      $(".member_item").each ->
        if group_id == $(this).data().team.toString()
          $(this).show()
        else
          $(this).hide()
    else
      $(".member_item").show()

  $(document).on "input", "#name_search", ->
    keyword = $.trim($(this).val())
    if $("#leader_select").val()
      member = $(".all_member").find("[data-team=" + $("#leader_select").val() + "]")
    else
      member = $(".member_item")
    if keyword != ""
      keyword = keyword.toLowerCase();
      member.each ->
        if $(this).find(".user_name").data().id.indexOf(keyword) >= 0
          $(this).show()
        else
          $(this).hide()
    else
      member.show()