jQuery ->
  $question_form = jQuery(".page-question-form .question-form")
  $add = $question_form.find(".add-choice")
  $choice = $question_form.find(".choice")

  $add.on "click", ->
    $choice.clone().show().insertAfter(jQuery(this).parent())

  jQuery(document).on "click", ".remove-choice", ->
    jQuery(this).parent().remove()
