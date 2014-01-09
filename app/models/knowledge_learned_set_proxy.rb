class KnowledgeLearnedSetProxy
  def self.is_unlocked?(set, user)
    set.parents.each do |parent_set|
      if !KnowledgeLearned.is_learned?(parent_set, user)
        return false
      end
    end

    return true
  end


  def self.required_nodes_is_learned?(set, user)
    set.nodes.each do |node|
      if node.required
        if !KnowledgeLearned.is_learned?(node, user)
          return false
        end
      end
    end
    return true
  end

  def self.learned_nodes_count(set, user)
    set.nodes.select do |node|
      KnowledgeLearned.is_learned?(node, user)
    end.count
  end
end