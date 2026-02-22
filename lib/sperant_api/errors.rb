# frozen_string_literal: true

module SperantApi
  class Error < StandardError; end

  class ConfigurationError < Error; end

  class ApiError < Error
    attr_reader :status_code, :response_body

    def initialize(message = nil, status_code: nil, response_body: nil)
      @status_code = status_code
      @response_body = response_body
      super(message || "API request failed (status: #{status_code})")
    end
  end

  class RateLimitError < ApiError
    def initialize(message = "Rate limit exceeded (15 requests per second)", status_code: 429, response_body: nil)
      super(message, status_code: status_code, response_body: response_body)
    end
  end
end
