$ ->
  $("#checkpoint_type").change ->
    switch $(this).val()
      when ("leader")
        $(".leader-1").show()
        $(".member-1").hide()
        $(".subleader-1").hide()
      when ("subleader")
        $(".leader-1").hide()
        $(".member-1").hide()
        $(".subleader-1").show()
      when ("member")
        $(".leader-1").hide()
        $(".member-1").show()
        $(".subleader-1").hide()
      else
        $(".leader-1").show()
        $(".member-1").show()
        $(".subleader-1").show()
    filter_data()

  $(document).on "input", "#questions_search", ->
    filter_data()

  filter_data = ()->
    keyword = $.trim($("#questions_search").val())
    slelected = $('#checkpoint_type option').filter(':selected').text().toLowerCase();
    if slelected == "all questions"
      slelected = "user-name"
    if keyword != ""
      keyword = keyword.toLowerCase();
      $("." + slelected + "-1").each ->
        if $(this).data().id.indexOf(keyword) >= 0
          $(this).show()
        else
          $(this).hide()
    else
      $("." + slelected + "-1").show()