$ ->
  if window.location.pathname == "/projects/gantt_list"
    $.ajax "/projects/gantt",
    type: "GET",
    dataType: "json"
    success: (data) ->
      $(".gantt").gantt
        source: data
        navigate: "scroll"
        scale: "weeks"
        maxScale: "months"
        minScale: "days"
        itemsPerPage: 50
        onItemClick: (data) ->

        onAddClick: (dt, rowId) ->

        onRender: ->
