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
end
