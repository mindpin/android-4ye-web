class KnowledgeLearned
  include Mongoid::Document
  include Mongoid::Timestamps

  field :user_id,     :type => Integer
  field :model_type,  :type => String
  field :model_id,    :type => String
  field :course,      :type => String

  validates :model_id, :uniqueness => {
    :scope => [:user_id, :model_type, :course]
  }

  def self.create_by_params(params)
    KnowledgeLearned.create(
      :user_id  => params[:user].id,
      :model_id => params[:model].id,
      :model_type => params[:model].class.name,
      :course => params[:model].net.name
    )
  end

  def self.is_learned?(model, user)
    KnowledgeLearned.where(
      :course     => model.net.name,
      :model_id   => model.id,
      :model_type => model.class.name,
      :user_id    => user.id
    ).exists?
  end

  def self.node_is_unlocked?(node, user)
    if node.is_root?
      return self.set_is_unlocked?(node.set, user)
    end

    node.parents.each do |parent_node|
      if !self.is_learned?(parent_node, user)
        return false
      end
    end

    return true
  end

  def self.set_is_unlocked?(set, user)
    set.parents.each do |parent_set|
      if !self.is_learned?(parent_set, user)
        return false
      end
    end

    return true
  end

  def self.set_required_node_is_learned?(set, user)
    set.nodes.each do |node|
      if node.required
        if !self.is_learned?(node, user)
          return false
        end
      end
    end
    return true
  end

  def self.checkpoint_include_set_is_learned?(checkpoint, user)
    checkpoint.learned_sets.each do |set|
      if !self.is_learned?(set, user)
        return false
      end
    end
    return true
  end

  def self.node_do_learn(node, user)
    self.create_by_params(:user => user, :model => node)

    if self.set_required_node_is_learned?(node.set, user)
      self.create_by_params(:user => user, :model => node.set)

      child = node.set.children.first
      if child.class == KnowledgeSpaceNetLib::KnowledgeCheckpoint
        if self.checkpoint_include_set_is_learned?(child, user)
          self.create_by_params(:user => user, :model => child)
        end
      end
    end
  end

  def self.checkpoint_do_learn(checkpoint, user)
    checkpoint.learned_sets.each do |set|
      set.nodes.each do |node|
        self.node_do_learn(node, user)
      end
    end
  end
end