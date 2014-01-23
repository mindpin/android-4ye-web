class Concept
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, :type => String
  field :desc, :type => String
  field :knowledge_node_id, :type => String
  field :knowledge_net_id, :type => String

  has_and_belongs_to_many :questions
  has_many :concept_test_records

  def test_count(user)
    record = ConceptTestRecord.where(:user_id => user.id, :concept_id => self.id).first
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

  module UserMethods
    def learned_concepts(net_id)
      node_ids = self.learned_knowledge_node_ids(net_id)
      Concept.concepts_from(net_id, node_ids)
    end

    def can_learn_concepts(net_id)
      node_ids = self.can_learn_knowledge_node_ids(net_id)
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
