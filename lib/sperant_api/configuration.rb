# frozen_string_literal: true

module SperantApi
  # Configuración del cliente: token, entorno y tamaño de página.
  # Se valida el entorno al asignar y el token al asignar o al llamar a {#validate!}.
  class Configuration
    # @return [String, nil] Token API Key proporcionado por Sperant.
    attr_accessor :access_token
    # @return [Symbol] Entorno: +:test+ (api.eterniasoft.com) o +:production+ (api.sperant.com).
    attr_accessor :environment
    # @return [Integer] Tamaño de página por defecto para listados (p. ej. 20).
    attr_accessor :page_size

    # @param access_token [String, nil] Token de la API (opcional en la construcción).
    # @param environment [Symbol, String] +:test+ o +:production+. Por defecto +:test+.
    # @param page_size [Integer] Número de elementos por página (por defecto 20).
    def initialize(access_token: nil, environment: Constants::ENVIRONMENTS.first, page_size: Constants::DEFAULT_PAGE_SIZE)
      @access_token = access_token
      @environment = environment.to_sym
      @page_size = page_size
      validate_environment!
      validate_token! if access_token
    end

    # @param value [Symbol, String] +:test+ o +:production+.
    def environment=(value)
      @environment = value.to_sym
      validate_environment!
    end

    # @param value [String, nil] Token de la API.
    def access_token=(value)
      @access_token = value
      validate_token!
    end

    # URL base según el entorno configurado.
    # @return [String] URL base (ej. https://api.eterniasoft.com o https://api.sperant.com).
    # @raise [ConfigurationError] Si el entorno no es reconocido.
    def base_url
      base = Constants::BASE_URLS[environment]
      raise ConfigurationError, "Unknown environment: #{environment}" unless base

      base
    end

    # Valida token y entorno. Útil antes de realizar peticiones.
    # @raise [ConfigurationError] Si el token está vacío o el entorno es inválido.
    def validate!
      validate_token!
      validate_environment!
    end

    private

    def validate_token!
      token = access_token.to_s.strip
      raise ConfigurationError, "access_token is required" if token.empty?
    end

    def validate_environment!
      return if Constants::ENVIRONMENTS.include?(environment)

      raise ConfigurationError,
            "Invalid environment: #{environment}. Must be one of: #{Constants::ENVIRONMENTS.join(', ')}"
    end
  end
end
