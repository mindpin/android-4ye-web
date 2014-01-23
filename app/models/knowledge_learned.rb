class KnowledgeLearned
  include Mongoid::Document
  include Mongoid::Timestamps

  field :user_id,     :type => Integer
  field :model_type,  :type => String
  field :model_id,    :type => String
  field :net_id,      :type => String

  validates :model_id, :uniqueness => {
    :scope => [:user_id, :model_type, :net_id]
  }

  def self.create_by_params(params)
    KnowledgeLearned.create(
      :user_id  => params[:user].id,
      :model_id => params[:model].id,
      :model_type => params[:model].class.name,
      :net_id => params[:model].net.id
    )
  end

  def self.is_learned?(model, user)
    KnowledgeLearned.where(
      :net_id     => model.net.id,
      :model_id   => model.id,
      :model_type => model.class.name,
      :user_id    => user.id
    ).exists?
  end



  module UserMethods
    def get_history_experience(net_id)
      today = Time.now.to_date

      day_4 = self.get_by_day(net_id, today - 4.day)
      day_3 = self.get_by_day(net_id, today - 3.day)
      day_2 = self.get_by_day(net_id, today - 2.day)
      day_1 = self.get_by_day(net_id, today - 1.day)
      day_0 = self.get_by_day(net_id, today)

      [day_4, day_3, day_2, day_1, day_0]
    end

    def query_knowledge_nodes(net_id, is_learned, is_unlocked)
      net_adapter = KnowledgeNetAdapter.find(net_id)

      net_adapter.node_adapters.select do |node_adapter|
        _query_knowledge_nodes_select(node_adapter, is_learned, is_unlocked)
      end
    end

    def query_knowledge_node_ids(net_id, is_learned, is_unlocked)
      query_knowledge_nodes(net_id, is_learned, is_unlocked).map do |node_adapter|
        node_adapter.node.id
      end
    end

    def _query_knowledge_nodes_select(node_adapter, is_learned, is_unlocked)
      learned_select = is_learned.nil? ? true : node_adapter.is_learned?(self) == is_learned
      unlocked_select = is_unlocked.nil? ? true : node_adapter.is_unlocked?(self) == is_unlocked

      learned_select && unlocked_select
    end

    def learned_knowledge_nodes(net_id)
      query_knowledge_nodes(net_id, true, true)
    end

    def learned_knowledge_node_ids(net_id)
      learned_knowledge_nodes(net_id).map do |node_adapter|
        node_adapter.node.id
      end
    end

    def can_learn_knowledge_nodes(net_id)
      query_knowledge_nodes(net_id, false, true)
    end

    def can_learn_knowledge_node_ids(net_id)
      can_learn_knowledge_nodes(net_id).map do |node_adapter|
        node_adapter.node.id
      end
    end

    def locked_knowledge_nodes(net_id)
      query_knowledge_nodes(net_id, false, false)
    end

    def locked_knowledge_node_ids(net_id)
      locked_knowledge_nodes(net_id).map do |node_adapter|
        node_adapter.node.id
      end
    end

  end
end