module ServiceTemplate
  class JsonError
    def initialize(code, detail)
      @code = code
      @detail = detail
    end

    def to_json(options = {})
      to_h.to_json(options)
    end

    def to_h
      e = {
        error: {
          code: @code,
          detail: @detail
        }
      }
    end
  end
end
