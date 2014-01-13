raw_data = YAML.load_file("script/data/javascript_questions.yaml")

query = Question.where(:knowledge_net_id => "javascript")
query.destroy_all if query.count > 0

raw_data.each do |hash|
  question = Question.new(hash)
  question.content_type = "markdown_format"
  question.knowledge_net_id = "javascript"
  question.save
end

puts query.count
