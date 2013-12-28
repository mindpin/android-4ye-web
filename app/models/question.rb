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
    return "单选题" if is_single_choice
    return "多选题" if is_multiple_choice
    return "判断题" if is_true_false
    return "填空题" if is_fill
    "单选题"
  end

  def self.from_json(json)
    hash = JSON.parse(json)
    self.new(hash)
  end

  module KnowledgeNodeRandomQuesiton
    def get_random_question(except_ids)
      questions = Question.where(:_id.nin => except_ids)
      count = questions.count
      return if count == 0

      offset = (0..(count - 1)).sort_by{rand}.first
      questions.skip(offset).first
    end
  end
end
