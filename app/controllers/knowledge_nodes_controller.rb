class KnowledgeNodesController < ApplicationController

  before_filter :pre_load
  
  def pre_load
    @net_id = params[:net_id] if params[:net_id]
    @net = KnowledgeNetAdapter.find(@net_id)

    @node = @net.find_node_adapter_by_id(params[:id]) if params[:id]
  end

  def test_success
    add_exp_num = @node.do_learn(current_user)
    today = Time.now.to_date

    day_4 = KnowledgeLearned.get_exp_by_day(current_user, @net_id, today - 4.day)
    day_3 = KnowledgeLearned.get_exp_by_day(current_user, @net_id, today - 3.day)
    day_2 = KnowledgeLearned.get_exp_by_day(current_user, @net_id, today - 2.day)
    day_1 = KnowledgeLearned.get_exp_by_day(current_user, @net_id, today - 1.day)
    day_0 = KnowledgeLearned.get_exp_by_day(current_user, @net_id, today)

    render :json => {
                      :add_exp_num => add_exp_num,
                      :history_info => [day_4, day_3, day_2, day_1, day_0]
                    }
  end

end
