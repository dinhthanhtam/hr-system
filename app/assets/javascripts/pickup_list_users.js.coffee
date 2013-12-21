$ ->
  $(document).on "click", ".add_member_to_list", ->
    members = $("input[name*='member[]']:checked").map(->
      $(this).val()
    ).get()
    
    pickup_list = {}
    pickup_list["id"] = $("#pickup_list_id").val()
    i = 0
    pickup_list["pickup_list_users_attributes"] = []
    pickup_list_user_attr = {}
    while i < members.length
      pickup_list["pickup_list_users_attributes"].push({'user_id': members[i]})
      i++
    $.ajax "/pickup_lists/assign_members",
        type: "POST",
        data: {pickup_list:pickup_list}
        success: (data)->
          window.location.reload()

  $(".pickup-list-member").mouseover ->
    member_id = this.id.replace("tr-pickup-list-member-", "")
    $("#delete-user-" + member_id).css "display", "block"

  $(".pickup-list-member").mouseout ->
    member_id = this.id.replace("tr-pickup-list-member-", "")
    $("#delete-user-" + member_id).css "display", "none"