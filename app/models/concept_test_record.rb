class ConceptTestRecord
  include Mongoid::Document
  include Mongoid::Timestamps

  field :user_id, :type => Integer
  field :correct_count, :type => Integer, :default => 0
  field :error_count, :type => Integer, :default => 0

  belongs_to :concept

  validates :concept_id, :uniqueness => {:scope => [:user_id]} 

  def self.get_by(user, concept)
    where(:user_id => user.id, :concept_id => concept.id)
  end

  def self.init_by(user, concept)
    relation = self.get_by(user, concept)
    relation.first ? relation.first : relation.create
  end

  def do_correct!
    inc(:correct_count, 1)
  end

  def do_error!
    inc(:error_count, 1)
  end

  def total_tests
    correct_count + error_count
  end
end
