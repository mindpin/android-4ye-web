class Concept
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, :type => String
  field :desc, :type => String
  field :knowledge_node_id, :type => String
  field :knowledge_net_id, :type => String
  field :_bid, :type => String

  has_and_belongs_to_many :questions
  has_many :concept_test_records

  before_create :set_bid
  def set_bid
    self._bid = randstr
  end

  def test_count(user)
    record = ConceptTestRecord.get_by(user, self).first
    record ? record.total_tests : 0
  end

  def do_correct(user)
    ConceptTestRecord.init_by(user, self).do_correct!
  end
  
  def do_error(user)
    ConceptTestRecord.init_by(user, self).do_error!
  end

  def learned_node_questions(user)
    node_ids = user.learned_knowledge_node_ids(knowledge_net_id)
    Question.where(:knowledge_node_id.in => node_ids, :_id.in => question_ids)
  end

  def self.concepts_from(net_id, node_ids)
    where(:knowledge_node_id.in => node_ids, :knowledge_net_id => net_id)
  end

  def knowledge_net_adapter
    KnowledgeNetAdapter.find(knowledge_net_id)
  end

  def knowledge_node_adapter
    knowledge_net_adapter.find_node_adapter_by_id(knowledge_node_id)
  end
    
  def to_hash(user)
    {
      :id   => self.id,
      :name => self.name,
      :desc => self.desc,
      :is_learned => knowledge_node_adapter.is_learned?(user),
      :is_unlocked => knowledge_node_adapter.is_unlocked?(user),
      :practicing_count => ConceptTestRecord.init_by(user, self).total_tests
    }
  end

  module UserMethods
    def learned_concepts(net_id)
      node_ids = self.learned_knowledge_node_ids(net_id)
      Concept.concepts_from(net_id, node_ids)
    end

    def can_learn_concepts(net_id)
      node_ids = self.can_learn_knowledge_node_ids(net_id)
      Concept.concepts_from(net_id, node_ids)
    end

    def locked_concepts(net_id)
      node_ids = self.locked_knowledge_node_ids(net_id)
      Concept.concepts_from(net_id, node_ids)
    end

    def query_concepts(net_id, is_learned, is_unlocked)
      node_ids = self.query_knowledge_node_ids(net_id, is_learned, is_unlocked)
      Concept.concepts_from(net_id, node_ids)
    end

    def learned_node_random_questions_for_concept(concept, number = 1)
      questions = concept.learned_node_questions(self)
      count = questions.count
      return [] if count == 0

      offsets = (0..(count - 1)).sort_by{rand}.slice(0, number).collect
      offsets.map {|offset| questions.skip(offset).first}
    end
  end

  module QuestionMethods
    def do_correct(user)
      concepts.each do |concept|
        concept.do_correct(user)
      end
    end

    def do_error(user)
      concepts.each do |concept|
        concept.do_error(user)
      end
    end
  end
end
