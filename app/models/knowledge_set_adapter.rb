class KnowledgeSetAdapter
  attr_reader :set
  def initialize(set)
    @set = set
  end

  def is_learned?(user)
    KnowledgeLearned.is_learned?(@set, user)
  end

  def is_unlocked?(user)
    KnowledgeLearnedSetProxy.is_unlocked?(@set, user)
  end
end