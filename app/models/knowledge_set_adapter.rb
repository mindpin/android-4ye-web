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
      :id   => @set.id,
      :name => @set.name,
      :icon => @set.icon,
      :deep => @set.deep,
      :is_learned  => self.is_learned?(user),
      :node_count  => self.set.nodes.count,
      :learned_node_count => self.learned_node_count(user),
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

  def concepts
    ids = @set.nodes.map{|node|node.id}
    Concept.where(:knowledge_node_id.in => ids, :knowledge_net_id => @set.net.id)
  end
end