module Krack
  class Error
    attr_accessor :status

    def initialize(status=500)
      @status = Rack::Utils::HTTP_STATUS_CODES.has_key?(status) ? status : 500
    end

    def to_h
      {error: {status: status, message: Rack::Utils::HTTP_STATUS_CODES[status]}}
    end
  end
end
