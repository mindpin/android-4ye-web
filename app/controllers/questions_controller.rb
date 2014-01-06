class QuestionsController < ApplicationController
  def index
    @nets = KnowledgeSpaceNetLib::KnowledgeNet.all
  end

  def net
    @net = KnowledgeSpaceNetLib::KnowledgeNet.find(params[:id])
  end
  
  def set
    @net = KnowledgeSpaceNetLib::KnowledgeNet.find(params[:net_id])
    @set = @net.find_set_by_id(params[:id])
  end

  def node
    @net = KnowledgeSpaceNetLib::KnowledgeNet.find(params[:net_id])
    @node = @net.find_node_by_id(params[:id])
    @questions = Question.where(:knowledge_node_id => @node.id)
  end

  def list
    @questions = Question.all
  end

  def new
    @net = KnowledgeSpaceNetLib::KnowledgeNet.find(params[:net_id])
    @question = Question.new
    @node = @net.find_node_by_id(params[:node_id])
  end

  def edit
    @question = Question.find(params[:id])
    @yaml = @question ? @question.to_yaml.split("\n")[1..-1].join("\n") : ""
  end

  def create
    @question = Question.from_yaml(params[:yaml])
    @question.knowledge_node_id = params[:node_id]
    @question.knowledge_net_id = params[:net_id]
    @question.save
    redirect_to node_questions_path(
      :id     => @question.knowledge_node_id,
      :net_id => @question.knowledge_net_id
    )
  end

  def update
    hash = YAML.load(params[:yaml])
    @question = Question.find(params[:id])
    @question.update_attributes hash
    @question.knowledge_node_id = params[:node_id]
    @question.knowledge_net_id = params[:net_id]
    @question.save
    redirect_to :back
  end

  def destroy
    @question = Question.find(params[:id])
    @question.destroy if @question
    redirect_to :action => :index
  end
end
