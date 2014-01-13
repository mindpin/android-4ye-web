raw_data = YAML.load_file("script/data/english_questions.yaml")

query = Question.where(:knowledge_net_id => "english")
query.destroy_all if query.count > 0

raw_data.each do |hash|
  question = Question.new(hash)
  question.content_type = "markdown_format"
  question.knowledge_net_id = "english"
  question.save
end

puts query.count
