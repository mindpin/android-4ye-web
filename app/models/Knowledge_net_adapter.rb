class KnowledgeNetAdapter
  attr_reader :net
  def initialize(net)
    @net = net
  end

  def self.test1_instance
    net = KnowledgeSpaceNetLib::KnowledgeNet.test1_instance
    self.new(net)
  end

  def self.find(name)
    net = KnowledgeSpaceNetLib::KnowledgeNet.find(name)
    self.new(net)
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