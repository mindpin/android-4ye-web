# coding: utf-8
require "question_content_parser"

class Question
  include Mongoid::Document
  include Mongoid::Timestamps

	SINGLE_CHOICE   = "single_choice"
	MULTIPLE_CHOICE = "multiple_choices"
	TRUE_FALSE      = "true_false"
  FILL            = "fill"

  STANDARD_FORMAT = "standard_format"
  MARKDOWN_FORMAT = "markdown_format"

  field :knowledge_node_id, :type => String
  field :knowledge_net_id,  :type => String
  field :kind,              :type => String
  field :content,           :type => String
  field :content_type,      :type => String
  field :choices,           :type => Array
  field :difficulty,        :type => String
  field :answer,            :type => String

  has_and_belongs_to_many :concepts
  
  validates :kind, :presence => true
  
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

  def net
    KnowledgeSpaceNetLib::KnowledgeNet.find(self.knowledge_net_id)
  end

  def set
    self.node.set
  end

  def node
    self.net.find_node_by_id(self.knowledge_node_id)
  end

  def make_content
    return MarkdownQuestionContentParser.new(content).parse if MARKDOWN_FORMAT == content_type
    StandardQuestionContentParser.new(content).output
  end

  def as_json(options={})
    json = super(options.merge :except => [:_id])
    json[:content] = make_content
    json[:id] = _id
    json
  end

  def available_concepts
    ids = node.ancestor_ids + [knowledge_node_id]
    Concept.where(:knowledge_node_id.in => ids, :knowledge_net_id => knowledge_net_id)
  end

  def self.from_json(json)
    self.new(JSON.parse(json))
  end

  def self.from_yaml(yaml)
    self.new(YAML.load(yaml))
  end

  def self.all_questions_for_node_id(net_id, node_id)
    Question.where(:knowledge_net_id => net_id, :knowledge_node_id => node_id)
  end

  def self.random_question_for_node_id(net_id, node_id, except_ids=[])
    result = self.random_questions_for_node_id(net_id, node_id, 1, except_ids)
    result ? result.first : result
  end

  def self.random_questions_for_node_id(net_id, node_id, number=1, except_ids=[])
    questions = all_questions_for_node_id(net_id, node_id).where(:_id.nin => except_ids)
    count = questions.count
    return if count == 0

    offsets = (0..(count - 1)).sort_by{rand}.slice(0, number).collect
    offsets.map {|offset| questions.skip(offset).first}
  end

  def self.formats
    [["标准录入格式", STANDARD_FORMAT], ["Markdown格式", MARKDOWN_FORMAT]]
  end

  def self.kinds
    [["单选题", SINGLE_CHOICE], ["多选题", MULTIPLE_CHOICE], ["判断题", TRUE_FALSE], ["填空题", FILL]]
  end
end
