raw_data = YAML.load_file("script/data/english_questions.yaml")

query_question = Question.where(:knowledge_net_id => "english")
query_question.destroy_all if query_question.count > 0

raw_data.each do |hash|
  hash.delete "concepts"

  hash["content"] = hash["content"].strip

  hash["choices"] = hash["choices"].map do |raw|
    raw.is_a?(String) ? raw.strip : raw
  end if hash["choices"]

  hash["answer"] = hash["answer"].strip if hash["answer"].is_a?(String)

  question = Question.new(hash)
  question.content_type = "markdown_format"
  question.knowledge_net_id = "english"
  question.save
end

puts query_question.count
