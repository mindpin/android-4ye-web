class KnowledgeLearnedCheckpointProxy
  def self.include_sets_is_learned?(checkpoint, user)
    checkpoint.learned_sets.each do |set|
      if !KnowledgeLearned.is_learned?(set, user)
        return false
      end
    end
    return true
  end

  def self.do_learn(checkpoint, user)
    if KnowledgeLearned.is_learned?(checkpoint, user)
      user.add_exp(checkpoint.net.id, 5, checkpoint, "")
      return LearnResult.new(5)
    end

    user.add_exp(checkpoint.net.id, 10, checkpoint, "")
    learned_item = self._do_learn_without_validate_and_exp(checkpoint, user)
    return LearnResult.new(10, learned_item)
  end

  def self._do_learn_without_validate_and_exp(checkpoint, user)
    learned_item = []
    checkpoint.learned_sets.each do |set|
      set.nodes.each do |node|
        items = KnowledgeLearnedNodeProxy._do_learn_without_validate_and_exp(node, user)
        learned_item += items
      end
    end

    learned_item
  end
end