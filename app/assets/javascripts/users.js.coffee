# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  $("form").on "change", "#user_position", ->
    $("#user_position_event").val($(this).val())
    switch $(this).val()
      when "manager", "submanager"
        $("#team").hide()
        $("#group").show()
      when "leader", "subleader", "member"
        $("#team").show()
        $("#group").hide()
      else
        $("#team").hide()
        $("#group").hide()

  $("form").on "change", "#group_select", ->
    group_id = $(this).val()
    select_team = $("#user_team_id")
    select_team.html("")
    $.ajax "/users/get_team",
        type: "GET",
        dataType: "json",
        data: {group_id: group_id}
        success: (data) ->
          $.each data, (key, value) ->
            option = "<option value =#{value[1]}>#{value[0]}</option>"
            select_team.append(option)

  $.each $(".datepicker"), (index, value) ->
    date_string = $(value).val().substring(0,10)
    date = new Date(date_string)
    today = new Date()
    todayString = "#{today.getFullYear().toString()}-#{today.getMonth().toString()}-#{today.getDate().toString()}"
    if date_string == ""
      if $(value).attr("name").indexOf("birthday") != -1
        $(value).val("1990-01-01")
      else
        $(value).val(todayString)
    $(value).datepicker
      format: "yyyy-mm-dd"
      autoclose: true
    $(value).val("") if date_string == ""

  $("li.group").click ->
    id = $(this).data("id")
    $(this).siblings().attr("class", "group")
    $(this).addClass("active")
    $(".group_table").hide()
    $("#"+id).show()

  $(".item_left_menu").click ->
    id_element = $(this).closest("tr").attr("id").split("_")[0]
    id = $(this).closest("tr").attr("id").split("_")[1]
    if id_element == "group"
      id_diff = "#team"
    else
      id_diff = "#group"
    $("#" + id_element).val(id)
    $(id_diff).val("")
    $("#search_by_name_form").submit()
  
  mark_left_menu = ->
    val_g = $("#group").val()
    val_t = $("#team").val()
    if (val_g != "")
      $("#group_" + val_g).addClass("active")
    if (val_t != "")
      $("#team_" + val_t).addClass("active")

  mark_left_menu()

  $(".attributes").click ->
    if $("#is_show_settings").val() == "true"
      $(".update_errors").remove()
      $(".data_settings").hide()
      $(".display_settings").show()
      $(".attributes").attr("class","attributes")
      $(this).find(".display_settings").hide()
      $(this).find(".data_settings").show()
      $(this).addClass("active")

  $(".attributes input[type!=button]").click (e)->
    e.stopPropagation()

  $(document).on "click", ".close_div", ->
    $(".attributes").attr("class","attributes")
    $(this).parent().hide()
    display_settings = $(this).closest("form").siblings(".display_settings")
    $(this).siblings("input[type=text]").val(display_settings.html())
    display_settings.show()
    $("input[type=password]").val("")

  $(document).on "click", ".close_feedback", ->
    $("#form_feedback").hide(500)
    $("#form_feedback .reset").val("")

  $(document).on "click", "body", ->
    $("#form_feedback").hide(500)
    $("#form_feedback .reset").val("")

  $(document).on "click", "#form_feedback", (e)->
    e.stopPropagation()

  $(".feedback a").click (e)->
    e.stopPropagation()
    $("#form_feedback").show(300)

  $("#avatar_file").change (e)->
    img = $(this).siblings("img")
    console.log $(this).files
    if this.files && this.files[0]
      reader = new FileReader()
      reader.onload = (e)->
        img.attr("src", e.target.result)
      reader.readAsDataURL(this.files[0])

  $(".advance_search").hide()

  $("#addvance_search").click ->
    if $(".advance_search").is(":visible")
      $(this).css("background-image", "url('/assets/icon_search.png')")
    else
      $(this).css("background-image", "url('/assets/icon_search_hide.png')")
    $(".advance_search").toggle(100)

  $("#search_name").keypress (e)->
    $("#search_by_name_form").submit() if (e.which == 13)

  $(".role_select").change ->
    role = @value
    if role == "all"
      location.reload()
    else
      $(".div_roles").children().each ->
        if $(this).attr("class").indexOf(role) == 4
          $(this).css("margin-top", "13px").show()
        else
          $(this).hide()
      if role == "chief"
        $("#chief_list").show()
        $(".group").hide()
      else
        $(".group").show()
        $("#chief_list").hide()
        $(".sortable-list").each ->
          if $(this).attr("data-role") == role
            $(this).css("margin-top", "13px").show()
          else
            $(this).hide()

  $(".toggle_group").click ->
    if $(".group_select").val() == "all"
      $(".group").show()
    $(".group").each ->
      if $(this).attr("data-group") == $(".group_select").val()
        $(this).toggle()