$ ->
  all_users = []
  name = []
  mapping = {}
  i = 0




  $.ajax "/users/get_all_user",
    type: "GET",
    dataType: "json"
    success: (data) ->
      users = $.each(data, (index,key) -> 
        all_users.push([data[index].id, data[index].display_name])
      )

  categoty_type = $("#report_report_category_id").val()
  if(categoty_type == "4")
    $("#tr_user_support").show()
  else
    $("#tr_user_support").hide()

  split = (val) ->
    val.split /,\s*/
  extractLast = (term) ->
    split(term).pop()

  $(document).on "change", "input[name='report[report_category_id]']", ->
    categoty_type = $(this).val()
    if(categoty_type == "4")
      $("#tr_user_support").show()
    else
      $("#tr_user_support").hide()




  # don't navigate away from the field on tab when selecting an item
  $("#tags").bind("keydown", (event) ->
    while i < all_users.length
      name.push(all_users[i][1])
      mapping[all_users[i][1]] = all_users[i][0]
      ++i
    event.preventDefault()  if event.keyCode is $.ui.keyCode.TAB and $(this).data("ui-autocomplete").menu.active
  ).autocomplete
    minLength: 0
    source: (request, response) ->
      # delegate back to autocomplete, but extract the last term
      response $.ui.autocomplete.filter(name, extractLast(request.term))

    focus: ->
      
      # prevent value inserted on focus
      false

    select: (event, ui) ->
      ids = $("#report_support_users").val().replace("[","").replace("]","").split(',')
      id = ui.item.value

      if $.inArray(id.toString(), ids) < 0
        ids.push id
        $("div.tag-badge").append('<span class="tag-name">' + id + '&nbsp;<img class="clear_support" src="/assets/ico_tag_delete.png" data-id = "' + id + '"></span>')
      terms = split(@value)
      # remove the current input
      terms.pop()
      # add the selected item
      terms.push ui.item.value

      # add placeholder to get the comma-and-space at the end
      ids = ids.join(",")
      if ids.match("^,")
        ids = ids.substring(1);
      $("#report_support_users").val(ids)
      terms.push ""
      
      @value = ""
      false
  $(document).on "click", ".clear_support", ->
    ids = $("#report_support_users").val().replace("[","").replace("]","").split(',')
    id = $(this).data("id")
    index = $.inArray(id.toString(), ids);
    if index >= 0
      ids.splice(index, 1)
      $(this).closest("span.tag-name").remove()
    ids = ids.join(",")
    if ids.match("^,")
      ids = ids.substring(1);
    $("#report_support_users").val(ids)

  $(document).on "click", "#head_nav a", (e)->
    e.preventDefault()
    $(this).tab "show"



