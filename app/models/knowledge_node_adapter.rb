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

    if self.is_learned?(user)
      user.add_exp(@node.net.name, 5, @node, "")
      return 
    end

    user.add_exp(@node.net.name, 10, @node, "")
    KnowledgeLearned.node_do_learn(@node, user)
  end
end