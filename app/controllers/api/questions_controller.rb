class Api::QuestionsController < ApplicationController
  def do_answer
    @question = Question.find(params[:id])
    case params[:answer]
      when "true"
        @question.do_correct(current_user)
      when "false"
        @question.do_error(current_user)
    end

    render :text => 200
  end
end
