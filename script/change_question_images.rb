query = Question.where(:knowledge_net_id => "english")

query.each do |question|
  has_images = []
  has_images << !question.content.match(/images\/.*\.jpg/).blank?

  if !question.choices.blank?
    question.choices.each do |choice|
      has_images << !choice.match(/images\/.*\.jpg/).blank?
    end
  end

  next if has_images.select{|f|f}.count == 0

  content = question.content.gsub(/!\[.*\]/) do |file_tag|
    file_path = file_tag.match(/images\/.*\.jpg/)[0]

    file_path = File.join("/download/question_images/", file_path)

    id = ImageData.create(:file => File.new(file_path))
    "![#{id.file.url}]"
  end

  if !question.choices.blank?
    choices = question.choices.map do |choice|
      choice.gsub(/!\[.*\]/) do |file_tag|
        file_path = file_tag.match(/images\/.*\.jpg/)[0]

        file_path = File.join("/download/question_images/", file_path)

        id = ImageData.create(:file => File.new(file_path))
        "![#{id.file.url}]"
      end
    end
  end


  question.content = content
  if !question.choices.blank?
    question.choices = choices
  end
  question.save
  p question
end

puts query.count
