class KnowledgeNetAdapter
  attr_reader :net
  def initialize(net)
    @net = net
  end

  def set_adapters
    @net.sets.map do |set|
      KnowledgeSetAdapter.new(set)
    end
  end

  def checkpoint_adapters
    @net.checkpoints.map do |checkpoint|
      KnowledgeCheckpointAdapter.new(checkpoint)
    end
  end

  def sets_hash(user)
    sets = self.set_adapters.map do |sa|
      {
        :id   => sa.set.id,
        :name => sa.set.name,
        :icon => sa.set.icon,
        :deep => sa.set.deep,
        :is_learned  => sa.is_learned?(user),
        :node_count  => sa.set.nodes.count,
        :learned_node_count => sa.learned_node_count(user)
      }
    end

    checkpoints = self.checkpoint_adapters.map do |ca|
      {
        :id => ca.checkpoint.id,
        :deep => ca.checkpoint.deep,
        :learned_sets => ca.learned_set_adapters.map{|sa|sa.set.id},
        :is_learned  => ca.is_learned?(user)
      }
    end

    relations = self.net.relations.map do |relation|
      {
        :parent => relation.parent.id,
        :child  => relation.child.id
      }
    end

    status = user.experience_status(self.net.id)
    {
      :total_exp_num => status.total_exp_num,
      :id   => self.net.id,
      :name => self.net.name,
      :sets => sets,
      :checkpoints => checkpoints,
      :relations => relations
    }
  end

  def self.find(id)
    net = KnowledgeSpaceNetLib::KnowledgeNet.find(id)
    self.new(net)
  end

  def self.list_hash
    nets = KnowledgeSpaceNetLib::KnowledgeNet.all
    nets.map do |net|
      {:id => net.id, :name => net.name}
    end
  end

  def find_node_adapter_by_id(node_id)
    node = @net.find_node_by_id(node_id)
    KnowledgeNodeAdapter.new(node)
  end

  def find_set_adapter_by_id(set_id)
    set = @net.find_set_by_id(set_id)
    KnowledgeSetAdapter.new(set)
  end

  def find_checkpoint_adapter_by_id(checkpoint_id)
    checkpoint = @net.find_checkpoint_by_id(checkpoint_id)
    KnowledgeCheckpointAdapter.new(checkpoint)
  end

end