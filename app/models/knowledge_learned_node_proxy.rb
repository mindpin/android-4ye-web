class KnowledgeLearnedNodeProxy
  def self.is_unlocked?(node, user)
    if node.is_root?
      return KnowledgeLearnedSetProxy.is_unlocked?(node.set, user)
    end

    node.parents.each do |parent_node|
      if !KnowledgeLearned.is_learned?(parent_node, user)
        return false
      end
    end

    return true
  end

  def self.do_learn(node, user)
    return if !KnowledgeLearnedNodeProxy.is_unlocked?(node, user)

    if KnowledgeLearned.is_learned?(node, user)
      user.add_exp(node.net.id, 5, node, "")
      return 
    end

    user.add_exp(node.net.id, 10, node, "")
    self._do_learn_without_validate_and_exp(node, user)
  end

  def self._do_learn_without_validate_and_exp(node, user)
    KnowledgeLearned.create_by_params(:user => user, :model => node)

    if KnowledgeLearnedSetProxy.required_nodes_is_learned?(node.set, user)
      KnowledgeLearned.create_by_params(:user => user, :model => node.set)

      child = node.set.children.first
      if child.class == KnowledgeSpaceNetLib::KnowledgeCheckpoint
        if KnowledgeLearnedCheckpointProxy.include_sets_is_learned?(child, user)
          KnowledgeLearned.create_by_params(:user => user, :model => child)
        end
      end
    end
  end
end