class KnowledgeLearned
  include Mongoid::Document
  include Mongoid::Timestamps

  field :user_id,     :type => Integer
  field :model_type,  :type => String
  field :model_id,    :type => String
  field :course,      :type => String

  validates :model_id, :uniqueness => {
    :scope => [:user_id, :model_type, :course]
  }

  def self.create_by_params(params)
    id = case params[:model]
    when KnowledgeSet
      params[:model].set_id
    when KnowledgeNode
      params[:model].node_id
    when KnowledgeCheckpoint
      params[:model].checkpoint_id
    end
    KnowledgeLearned.create(
      :user_id  => params[:user].id,
      :model_id => id,
      :model_type => params[:model].class.name,
      :course => params[:course]
    )
  end
end