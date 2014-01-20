class Api::KnowledgeSetsController < ApplicationController
  def show
    @net_adapter = KnowledgeNetAdapter.find(params[:knowledge_net_id])
    @set_adapter = @net_adapter.find_set_adapter_by_id(params[:id])

    render :json => @set_adapter.nodes_hash(current_user)
  end
end