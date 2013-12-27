$ ->
  if window.location.pathname == "/projects/gantt_list"
    $.ajax "/projects/gantt",
    type: "GET",
    dataType: "json"
    success: (data) ->
      $(".gantt").gantt
        source: data
        navigate: "scroll"
        scale: $("#gantt_scale").val()
        itemsPerPage: 50
        onItemClick: (data) ->
          alert "Project: " + data

  $("#gantt_scale").change ->
    window.location.href = window.location.href.split("?")[0] + "?gantt_scale=" + $(this).val()
