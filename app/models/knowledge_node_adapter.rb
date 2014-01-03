class KnowledgeNodeAdapter
  attr_reader :node
  def initialize(node)
    @node = node
  end

  def is_learned?(user)
    KnowledgeLearned.is_learned?(@node, user)
  end

  def is_unlocked?(user)
    KnowledgeLearned.node_is_unlocked?(@node, user)
  end

  def do_learn(user)
    return if !self.is_unlocked?(user)
    return if self.is_learned?(user)
    KnowledgeLearned.node_do_learn(@node, user)
  end
end