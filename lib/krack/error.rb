module Krack
  class Error < StandardError

    attr_accessor :status

    def initialize(status=500)
      @status = status
    end

    def respond
      {error: {status: status, message: Rack::Utils::HTTP_STATUS_CODES[status]}}
    end
  end
end
