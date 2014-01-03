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
    if is_learned?(user)
      user.add_exp(@checkpoint.net.name, 5, @checkpoint, "")
      return
    end

    user.add_exp(@checkpoint.net.name, 10, @checkpoint, "")
    KnowledgeLearned.checkpoint_do_learn(@checkpoint, user)
  end
end