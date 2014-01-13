raw_data = YAML.load_file("script/data/javascript_questions.yaml")

Question.destroy_all if Question.count > 0

raw_data.each do |hash|
  question = Question.new(hash)
  question.content_type = "markdown_format"
  question.knowledge_net_id = "javascript"
  question.save
end

puts Question.count
