query = Question.where(:knowledge_net_id => "english")

query.each do |question|
  next if question.content.match(/node_.*\/.*\.png/).blank?

  content = question.content.gsub(/!\[.*\]/) do |file_tag|
    file_path = file_tag.match(/node_.*\/.*\.png/)[0]

    file_path = File.join("/download/question_images/", file_path)

    id = ImageData.create(:file => File.new(file_path))
    "![#{id.file.url}]"
  end

  question.content = content
  question.save
  p question
end

puts query.count