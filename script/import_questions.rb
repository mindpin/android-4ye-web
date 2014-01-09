raw_data = YAML.load_file("script/data/javascript_questions.yaml")

raw_data.each do |hash|
  question = Question.new(hash)
  question.knowledge_net_id = "javascript"
  question.save
end

puts Question.count
