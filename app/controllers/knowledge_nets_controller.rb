class KnowledgeNetsController < ApplicationController
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

  def sets
    @net_adapter = KnowledgeNetAdapter.find(params[:id])
    render :json => @net_adapter.sets_hash(current_user)
  end
end