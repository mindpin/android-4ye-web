# coding: utf-8
class Question
  include Mongoid::Document

	SINGLE_CHOICE   = "single_choice"
	MULTIPLE_CHOICE = "multiple_choices"
	TRUE_FALSE      = "true_false"
  FILL            = "fill"

  field :knowledge_node_id, :type => String
  field :kind,              :type => String
  field :content,           :type => String
  field :choices,           :type => Array
  field :answer,            :type => String

  def is_single_choice?
    self.kind == SINGLE_CHOICE
  end

  def is_multiple_choices?
    self.kind == MULTIPLE_CHOICE
  end

  def is_true_false?
    self.kind == TRUE_FALSE
  end

  def is_fill?
    self.kind == FILL
  end

  def check_answer(input)
    self.answer == input
  end

  def get_kind_str
    case self.kind
    when MULTIPLE_CHOICE then "多选题"
    when TRUE_FALSE then "判断题"
    when FILL then "填空题"
    else "单选题"
    end
  end

  def self.from_json(json)
    self.new(JSON.parse(json))
  end

  def self.from_yaml(yaml)
    self.new(YAML.load(yaml))
  end

  def encode_with coder
    coder['knowledge_node_id'] = knowledge_node_id
    coder['kind'] = kind
    coder['content'] = content
    coder['choices'] = choices
    coder['answer'] = answer
    coder['difficulty'] = difficulty
  end

  module KnowledgeNodeRandomQuestion
    def all_questions
      Question.where(:knowledge_node_id => self.node_id)
    end

    def get_random_question(except_ids)
      questions = all_questions.where(:_id.nin => except_ids)
      count = questions.count
      return if count == 0

      offset = (0..(count - 1)).sort_by{rand}.first
      questions.skip(offset).first
    end
  end
end
