require "translator"
require "question_code_formatter"

class QuestionContentParser
  def initialize(content)
    @content = content
  end

  def image_translator
    if !@image_translator
      @image_translator ||= Translator::Single.new
      @image_translator.pattern = /^\!\[[^\]]*\]$/
      @image_translator.parser = lambda do |text|
        url = text[2..-2]

        {
          :type => :image,
          :data => {
            :url => url
          }
        }
      end
    end
    @image_translator
  end

  def code_translator
    if !@code_translator
      @code_translator ||= Translator::Wrapped.new
      @code_translator.start_pattern = /^```\w+$/
      @code_translator.end_pattern = /^```$/
      @code_translator.parser = lambda do |text|
        tokens = text.split("\n")
        lang = tokens[0][3..-1]
        raw = tokens[1..-2].join("\n")
        code = QuestionCodeFormatter.new(raw, lang).get_content
        
        {
          :type => :code,
          :data => {
            :lang => lang,
            :content => code
          }
        }
      end
    end
    @code_translator
  end

  def sequence
    @sequence ||= Translator::Sequence.new.add(code_translator, image_translator).feed(@content)
  end

  def parse
    sequence.translate.map do |content|
      next content if content.is_a?(Hash)
      {
        :type => :text,
        :data => {
          :content => content
        }
      }
    end
  end
end
