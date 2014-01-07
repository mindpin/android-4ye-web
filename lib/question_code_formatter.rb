require 'coderay'
require 'json'

class QuestionCodeFormatter
  def initialize(code_text, lang)
    @code_text = code_text
    @lang = lang

    @scan = CodeRay.scan(@code_text, @lang)
  end

  def get_content
    json = JSON.parse @scan.json
    block = []
    arr = []

    json.each { |x|
      type = x['type']
      kind = x['kind']
      text = x['text']
      action = x['action']

      case type
      when 'text'
        arr << [kind, text, block.last].compact
      when 'block'
        case action
        when 'open'
          block << kind
        when 'close'
          block.pop
        end
      end
    }

    return arr
  end
end

