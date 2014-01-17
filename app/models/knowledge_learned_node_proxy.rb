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
    return LearnResult.new(0) if !KnowledgeLearnedNodeProxy.is_unlocked?(node, user)

    if KnowledgeLearned.is_learned?(node, user)
      user.add_exp(node.net.id, 5, node, "")
      return LearnResult.new(5)
    end

    user.add_exp(node.net.id, 10, node, "")
    learned_items = self._do_learn_without_validate_and_exp(node, user)
    return LearnResult.new(10, learned_items)
  end

  def self._do_learn_without_validate_and_exp(node, user)
    learned_items = []
    if !KnowledgeLearned.is_learned?(node, user)
      learned_items << node
      KnowledgeLearned.create_by_params(:user => user, :model => node)
    end

    if KnowledgeLearnedSetProxy.required_nodes_is_learned?(node.set, user)
      if !KnowledgeLearned.is_learned?(node.set, user)
        learned_items << node.set
        KnowledgeLearned.create_by_params(:user => user, :model => node.set)
      end

      child = node.set.children.first
      if child.class == KnowledgeSpaceNetLib::KnowledgeCheckpoint
        if KnowledgeLearnedCheckpointProxy.include_sets_is_learned?(child, user)
          if !KnowledgeLearned.is_learned?(child, user)
            learned_items << child
            KnowledgeLearned.create_by_params(:user => user, :model => child)
          end
        end
      end
    end

    learned_items
  end
end