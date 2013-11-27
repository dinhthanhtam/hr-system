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
    $(value).datepicker format: "yyyy-mm-dd"
    $(value).datepicker("setDate", date) if date_string != ""
  $("li.group").click ->
    id = $(this).data("id")
    $(this).siblings().attr("class", "group")
    $(this).addClass("active")
    $(".group_table").hide()
    $("#"+id).show()
  $(".item_left_menu a").click ->
    id_element = $(this).attr("id").split("_")[0]
    id = $(this).attr("id").split("_")[1]
    if id_element == "group"
      id_diff = "#team"
    else
      id_diff = "#group"
    $("#" + id_element).val(id)
    $(id_diff).val("")
    $("#search_by_name_form").submit()
  
  mark_left_menu = ->
    $all_link = $(".item_left_menu").find("a")
    $all_link.attr("class", "item_left_menu")
    val_g = $("#group").val()
    val_t = $("#team").val()
    if (val_g != "")
      $("#group_" + val_g).addClass("active")
    if (val_t != "")
      $("#team_" + val_t).addClass("active")

  mark_left_menu()