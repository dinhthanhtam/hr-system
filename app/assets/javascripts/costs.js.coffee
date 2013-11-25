$ ->
  $("#only_monday").datepicker format: "yyyy-mm-dd"
  $("#only_monday").datepicker "setDaysOfWeekDisabled", "0,2,3,4,5,6"
