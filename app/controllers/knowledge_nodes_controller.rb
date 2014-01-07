class KnowledgeNodesController < ApplicationController

  before_filter :pre_load
  
  def pre_load
    @course = KnowledgeNetAdapter.find(params[:net_id]) if params[:net_id]
    @node = @course.find_node_adapter_by_id(params[:id]) if params[:id]
  end

  def test_success

    add_exp_num = @node.do_learn(current_user)

    day_4 = KnowledgeLearned.get_exp_by_day(current_user, @course, Time.now.to_date - 4.day)
    day_3 = KnowledgeLearned.get_exp_by_day(current_user, @course, Time.now.to_date - 3.day)
    day_2 = KnowledgeLearned.get_exp_by_day(current_user, @course, Time.now.to_date - 2.day)
    day_1 = KnowledgeLearned.get_exp_by_day(current_user, @course, Time.now.to_date - 1.day)
    day_now = KnowledgeLearned.get_exp_by_day(current_user, @course, Time.now.to_date)

    render :json => {
                      :add_exp_num    => add_exp_num,
                      :history_info => [day_4, day_3, day_2, day_1, day_now]
                    }
  end

end
