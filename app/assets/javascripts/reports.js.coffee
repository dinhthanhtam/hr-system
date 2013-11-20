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

  categoty_type = $('input[name="report[report_category_id]"]:checked').val()
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
      ids = $("#support_users").val().replace("[","").replace("]","").split(',')
      id = mapping[ui.item.value]
      times = new Date().getTime()
      name_nested_attributes = $("#support_users").data("name_nested_attributes")
      if $.inArray(id.toString(), ids) < 0
        ids.push id
        $("div.tag-badge").append('<span class="tag-name">' + ui.item.value + '&nbsp;<img class="clear_support" src="/assets/ico_tag_delete.png" data-id = "' + id + '"></span>')
        $("#div_support_users").append('<input type = "hidden" id ="support_' + id + '" name="' + name_nested_attributes + '[' + id + '][user_id]" value="' + id + '">')
      terms = split(@value)
      # remove the current input
      terms.pop()
      # add the selected item
      terms.push ui.item.value

      # add placeholder to get the comma-and-space at the end
      ids = ids.join(",")
      if ids.match("^,")
        ids = ids.substring(1);
      $("#support_users").val(ids)
      terms.push ""
      
      @value = ""
      false
  $(document).on "click", ".clear_support", ->
    ids = $("#support_users").val().replace("[","").replace("]","").split(',')
    id = $(this).data("id")
    index = $.inArray(id.toString(), ids);
    if index >= 0
      ids.splice(index, 1)
      $(this).closest("span.tag-name").remove()
      $("#div_support_users").find("input[id = 'support_#{id}']").remove()
      $("#div_support_users").find("div[id = 'div_#{id}']").find("input[name *= '_destroy']").val("1")
    ids = ids.join(",")
    if ids.match("^,")
      ids = ids.substring(1);
    $("#support_users").val(ids)

  $(document).on "click", "#head_nav a", (e)->
    e.preventDefault()
    $(this).tab "show"

  $("#report_report_date").datepicker format: "yyyy-mm-dd"

  $(document).on "click", "#view_charts", ->
    $.ajax "/reports/get_reports_by_user",
    type: "POST",
    data: {user_id: $("#user_id").val(),report_type: $("#report_type").val(),from: $("#report_from").val(),to: $("#report_to").val()},
    dataType: "json"
    success: (data) ->
      x_values = []
      y_values = []
      $.each data,(index) ->
        x_values.push data[index][0]
        y_values.push data[index][1]
      $("#container").highcharts
        title:
          text: "Daily Report"
          x: -20 #center

        subtitle:
          text: "Framgia.com"
          x: -20

        xAxis:
          categories: x_values

        yAxis:
          title:
            text: "Report (times)"

          plotLines: [
            value: 0
            width: 1
            color: "#808080"
          ]

        tooltip:
          valueSuffix: " times"

        legend:
          layout: "vertical"
          align: "right"
          verticalAlign: "middle"
          borderWidth: 0

        series: [
          name: "Report"
          data: y_values
        ]

  $(document).on "click", "#report_report_date", ->
    currDay = new Date
    firstDiff = currDay.getDate() - currDay.getDay() + 1
    mon = new Date(currDay.setDate(firstDiff))
    fri = new Date(currDay.setDate(firstDiff + 4))
    $(this).datepicker("setStartDate", mon)
    $(this).datepicker("setEndDate", fri)
