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
      return 5
    end

    user.add_exp(checkpoint.net.id, 10, checkpoint, "")
    self._do_learn_without_validate_and_exp(checkpoint, user)
    return 10
  end

  def self._do_learn_without_validate_and_exp(checkpoint, user)
    checkpoint.learned_sets.each do |set|
      set.nodes.each do |node|
        KnowledgeLearnedNodeProxy._do_learn_without_validate_and_exp(node, user)
      end
    end
  end
end