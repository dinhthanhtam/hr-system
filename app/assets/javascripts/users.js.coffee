# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  $("form").on "change", "#user_position", ->
    switch $(this).val()
      when "Manager", "Submanager"
        $("#team").hide()
        $("#group").show()
      when "Leader", "Subleader", "Staff"
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
    $(value).datepicker format: "dd/mm/yyyy"
    $(value).datepicker("setDate", date) if date_string != ""
  $("li.group").click ->
    id = $(this).data("id")
    $(this).siblings().attr("class", "group")
    $(this).addClass("active")
    $(".group_table").hide()
    $("#"+id).show()