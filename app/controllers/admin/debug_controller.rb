class Admin::DebugController < Admin::ApplicationController
  def index
  end

  def debug_net
    @net = KnowledgeSpaceNetLib::KnowledgeNet.find(params[:net_id])
  end

  def debug_set
    @net = KnowledgeSpaceNetLib::KnowledgeNet.find(params[:net_id])
    @set = @net.find_set_by_id(params[:set_id])
  end
end