jQuery ->
  $question_form = jQuery(".page-question-form .question-form")
  $add = $question_form.find(".add-choice")
  $choice = $question_form.find(".choice.template")

  $add.on "click", ->
    $choice.clone().removeClass("template").show().insertAfter(jQuery(this).parent())

  jQuery(document).on "click", ".remove-choice", ->
    jQuery(this).parent().remove()
