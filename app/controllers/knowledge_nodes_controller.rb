class KnowledgeNodesController < ApplicationController

  before_filter :pre_load
  
  def pre_load
    @net_id = params[:knowledge_net_id] if params[:knowledge_net_id]
    @net = KnowledgeNetAdapter.find(@net_id)

    @node = @net.find_node_adapter_by_id(params[:id]) if params[:id]
  end

  def test_success
    history_info = current_user.get_history_experience(@net_id)

    learn_result = @node.do_learn(current_user)

    render :json => {
                      :learned_items => learn_result.learned_items_hash,
                      :add_exp_num => learn_result.exp_num,
                      :history_info => history_info
                    }
  end

end
