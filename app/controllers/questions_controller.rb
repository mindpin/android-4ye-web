class QuestionsController < ApplicationController
  before_filter :is_admin
  def is_admin
    if !current_user.is_admin?
      render :status => 401, :text => 401
    end
  end

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

  def concepts
    @net = KnowledgeSpaceNetLib::KnowledgeNet.find(params[:net_id])
    @node = @net.find_node_by_id(params[:id])
    @concepts = KnowledgeNodeAdapter.new(@node).available_concepts
    @new = Concept.new(:knowledge_node_id => @node.id, :knowledge_net_id => @net.id)
  end
  
  def create_concept
    @concept = Concept.create(params[:concept])
    redirect_to :back
  end

  def destroy_concept
    @concept = Concept.find(params[:id])
    @concept.destroy if @concept
    redirect_to :back
  end
  
  def list
    @questions = Question.all
  end

  def new
    @net = KnowledgeSpaceNetLib::KnowledgeNet.find(params[:net_id])
    @question = Question.new
    @question.knowledge_net_id = @net.id
    @node = @net.find_node_by_id(params[:node_id])
    @question.knowledge_node_id = @node.id
  end

  def edit
    @question = Question.find(params[:id])
    @net = @question.net
    @node = @question.node
  end

  def create
    @question = Question.new(params[:question])
    @question.choices = nil if Question::TRUE_FALSE == params[:question][:kind]
    @question.save
    redirect_to node_questions_path(
      :id     => @question.knowledge_node_id,
      :net_id => @question.knowledge_net_id
    )
  end

  def update
    @question = Question.find(params[:id])
    @question.update_attributes(params[:question])
    @question.choices = nil if Question::TRUE_FALSE == params[:question][:kind]
    @question.concept_ids = [] if params[:question][:concept_ids].blank?
    @question.save
    redirect_to :back
  end

  def destroy
    @question = Question.find(params[:id])
    @question.destroy if @question
    redirect_to :action => :index
  end
end
