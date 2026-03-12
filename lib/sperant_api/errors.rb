# frozen_string_literal: true

module SperantApi
  # Error base de la gema. Todas las excepciones específicas heredan de esta.
  class Error < StandardError; end

  # Error de configuración: token faltante o inválido, entorno no permitido, etc.
  class ConfigurationError < Error; end

  # Error devuelto por la API (respuesta 4xx/5xx). Incluye código HTTP y cuerpo de respuesta.
  class ApiError < Error
    # @return [Integer, nil] Código de estado HTTP (ej. 404, 500).
    attr_reader :status_code
    # @return [String, nil] Cuerpo de la respuesta HTTP.
    attr_reader :response_body

    # @param message [String, nil] Mensaje de error (por defecto se genera con +status_code+).
    # @param status_code [Integer, nil] Código HTTP.
    # @param response_body [String, nil] Cuerpo de la respuesta.
    def initialize(message = nil, status_code: nil, response_body: nil)
      @status_code = status_code
      @response_body = response_body
      super(message || "API request failed (status: #{status_code})")
    end
  end

  # Límite de tasa superado (HTTP 429). Sperant permite 15 peticiones por segundo.
  class RateLimitError < ApiError
    # @param message [String] Mensaje por defecto sobre el límite de 15 req/s.
    # @param status_code [Integer] 429.
    # @param response_body [String, nil] Cuerpo de la respuesta.
    def initialize(message = "Rate limit exceeded (15 requests per second)", status_code: 429, response_body: nil)
      super(message, status_code: status_code, response_body: response_body)
    end
  end
end
