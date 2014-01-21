class KnowledgeNodeAdapter
  attr_reader :node
  def initialize(node)
    @node = node
  end

  def is_learned?(user)
    KnowledgeLearned.is_learned?(@node, user)
  end

  def is_unlocked?(user)
    KnowledgeLearnedNodeProxy.is_unlocked?(@node, user)
  end

  def do_learn(user)
    KnowledgeLearnedNodeProxy.do_learn(@node, user)
  end

  def available_concepts
    ids = @node.ancestor_ids + [@node.id]
    Concept.where(:knowledge_node_id.in => ids, :knowledge_net_id => @node.net.id)
  end
end
