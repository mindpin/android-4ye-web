class KnowledgeSetAdapter
  attr_reader :set
  def initialize(set)
    @set = set
  end

  def node_adapters
    @set.nodes.map do |node|
      KnowledgeNodeAdapter.new(node)
    end
  end

  def nodes_hash(user)
    nodes = node_adapters.map do |na|
      {
        :id       => na.node.id,
        :name     => na.node.name,
        :desc     => na.node.desc,
        :required => na.node.required,
        :is_unlocked => na.is_unlocked?(user),
        :is_learned  => na.is_learned?(user)
      }
    end

    relations = @set.relations.map do |relation|
      {
        :parent => relation.parent.id,
        :child  => relation.child.id
      }
    end

    {
      :nodes => nodes,
      :relations => relations
    }
  end

  def is_learned?(user)
    KnowledgeLearned.is_learned?(@set, user)
  end

  def is_unlocked?(user)
    KnowledgeLearnedSetProxy.is_unlocked?(@set, user)
  end

  def learned_node_count(user)
    KnowledgeLearnedSetProxy.learned_node_count(@set, user)
  end
end