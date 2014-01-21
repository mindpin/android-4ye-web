class Concept
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, :type => String
  field :desc, :type => String
  field :knowledge_node_id, :type => String
  field :knowledge_net_id, :type => String

  has_and_belongs_to_many :questions
end
