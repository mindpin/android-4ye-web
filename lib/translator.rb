module Translator
  class NoPatternError < Exception
  end

  class BufferEmptyError < Exception
  end

  class IllegalTokenError < Exception
  end

  class SingleTokenOnlyError < Exception
  end

  class IllegalTranslatorError < Exception
  end
  
  class Base
    attr_accessor :parser

    def translate
      raise BufferEmptyError.new if @buffer.empty?
      parser.call(buffer.join("\n"))
    end
    
    def flush!
      @buffer = []
    end

    def buffer
      @buffer ||= []
    end

    def add(token)
      raise IllegalTokenError.new if token.class != String
      buffer.push(token)
      self
    end

    private

    def get_pattern_from(civar)
      raise NoPatternError.new if !civar
      civar
    end
  end

  class Single < Base
    attr_writer :pattern

    def add(token)
      raise SingleTokenOnlyError.new if 1 == buffer.size
      super(token)
    end

    def match(token)
      self.pattern.match(token)
    end

    def pattern
      get_pattern_from @pattern
    end

    def working?
      false
    end
  end

  class Wrapped < Base
    attr_writer :start_pattern, :end_pattern

    def match(token)
      self.start_pattern.match(token)
    end

    def working?
      @working
    end

    def start!
      @working = true
    end

    def stop!
      @working = false
    end

    def start_pattern
      get_pattern_from @start_pattern
    end

    def end_pattern
      get_pattern_from @end_pattern
    end
  end

  class Sequence
    attr_reader :tokens

    def feed(text)
      @tokens = text.split("\n").reject(&:empty?)
      self
    end

    def sequence
      @sequence ||= []
    end

    def first_working
      (@sequence + [@plain_translator]).detect(&:working?)
    end

    def translate
      result = []
      while !tokens.empty? do
        token = tokens.shift

        sequence.any? do |trans|
          if trans.match(token)
            case trans
            when Wrapped
              trans.start!
              trans.add(token)

              while trans.working? do
                if trans.end_pattern.match(tokens.first)
                  trans.stop!
                end
                trans.add(tokens.shift)
              end
              result << trans.translate

              trans.flush!
            when Single
              trans.add(token)
              result << trans.translate
              trans.flush!
            end
            true
          end
        end ? result : result << token
      end
      result
    end

    def add(*translators)
      if translators.any? {|t| !t.is_a?(Translator::Base)}
        raise IllegalTranslatorError.new
      end
      sequence.concat(translators)
      self
    end
  end
end
