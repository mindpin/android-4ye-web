jQuery ->
  $question_form = jQuery(".page-question-form .question-form")
  $add = $question_form.find(".add-choice")
  $choice = $question_form.find(".choice.template")

  $add.on "click", ->
    $widgets = jQuery(this).closest(".control").find(".widgets")
    $clone = $choice.clone()
    $clone.removeClass("template").appendTo($widgets).slideDown();
    $widgets.slideDown() if $widgets.length > 0

  jQuery(document).on "click", ".remove-choice", ->
    $widgets = jQuery(this).closest(".widgets")
    jQuery(this).parent().slideUp ->
      jQuery(this).remove()
      $widgets.slideUp() if $widgets.children().length == 0
