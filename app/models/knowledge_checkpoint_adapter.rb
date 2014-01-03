class KnowledgeCheckpointAdapter
  attr_reader :checkpoint
  def initialize(checkpoint)
    @checkpoint = checkpoint
  end

  def is_learned?(user)
    KnowledgeLearned.is_learned?(@checkpoint, user)
  end

  def is_unlocked?(user)
    return true
  end

  def do_learn(user)
    KnowledgeLearnedCheckpointProxy.do_learn(@checkpoint, user)
  end
end