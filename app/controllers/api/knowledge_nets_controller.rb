class Api::KnowledgeNetsController < ApplicationController
  def exp_info
    status = current_user.experience_status(params[:id])
    render :json => {
                      :level            => status.level,
                      :level_up_exp_num => status.level_up_exp_num,
                      :exp_num          => status.exp_num
                    }
  end

  def list
    render :json => KnowledgeNetAdapter.list_hash
  end

  def show
    @net_adapter = KnowledgeNetAdapter.find(params[:id])
    render :json => @net_adapter.sets_hash(current_user)
  end

  def random_question
    result = Question.random_question_for_node_id(params[:net_id], params[:id])
    result = result ? result.as_json : result
    render :json => result
  end

  def random_questions
    render :json => Question.random_questions_for_node_id(params[:net_id], params[:id], 13).map {|question| question.as_json}
  end
end
