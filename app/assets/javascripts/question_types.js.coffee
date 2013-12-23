$ ->
  $(document).on "click", ".add_questions", ->
    members = $("input[name*='question_ids[]']:checked").map(->
      $(this).val()
    ).get()
    question_type = {}
    question_type["id"] = $("#question_type_id").val()
    i = 0
    question_type["question_type_relations_attributes"] = []
    question_type_user_attr = {}
    while i < members.length
      question_type["question_type_relations_attributes"].push({'question_id': members[i]})
      i++
    $.ajax "/question_types/add_questions",
        type: "POST",
        data: {question_type:question_type}
        success: (data)->
          window.location.reload(true)