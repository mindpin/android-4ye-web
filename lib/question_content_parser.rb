# coding: utf-8
require "translator"
require "question_code_formatter"

class StandardQuestionContentParser
  def initialize(content)
    @content = content
  end

  def output
    @line_num = 0
    @token = nil
    @output = []
    @lines_stack = []
    @code_lang = ''

    @content.each_line do |line|
      @line_num += 1
      s = line.strip

      case @token
      
      when nil
        deal_nil(s)        

      when 'image:'
        deal_image(s)

      when 'text:'
        deal_text(s)

      when 'code:'
        deal_code(s)

      end
    end

    @output
  end

  def is_token(s)
    return 'image:' if s == 'image:'
    return 'text:' if s == 'text:'

    if m = s.match(/code\:(.+)\:/)
      @code_lang = m[1]
      return 'code:'
    end

    return nil
  end

  def deal_nil(s)
    return if s == ''

    it = is_token(s)

    if it
      @token = s
      @lines_stack = []
    end

    # raise "第#{line_num}行：无法找到合理的段落类型标识"
  end

  def deal_image(s)
    url = s
    @output << {
      :type => :image,
      :data => {
        :url => url
      }
    }
    @token = nil
    @lines_stack = []
  end

  def deal_text(s)
    it = is_token(s)

    if it
      if @lines_stack.last == ''
        @output << {
          :type => :text,
          :data => {
            :content => pack_lines_stack
          }
        }

        @token = it
        @lines_stack = []
        return
      end
    end

    @lines_stack << s
  end

  def deal_code(s)
    it = is_token(s)

    if it
      if @lines_stack.last == ''
        @output << {
          :type => :code,
          :data => {
            :lang => @code_lang,
            :content => QuestionCodeFormatter.new(pack_lines_stack, @code_lang).get_content
          }
        }

        @token = it
        return
      end
    end

    @lines_stack << s
  end

  def pack_lines_stack
    str = @lines_stack.map { |x|
      x.sub /^raw\:/, ''
    }[0..-2] * "\n"

    @lines_stack = []
    return str
  end
end

class MarkdownQuestionContentParser
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
