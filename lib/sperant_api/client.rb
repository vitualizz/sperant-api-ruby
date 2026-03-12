# frozen_string_literal: true

module SperantApi
  # Punto de entrada principal: expone los recursos (proyectos, clientes, unidades)
  # y usa la configuración global o la pasada en la construcción.
  class Client
    # @return [Configuration] Configuración usada por este cliente.
    attr_reader :configuration
    # @return [Resources::Projects] Recurso para listar proyectos.
    attr_reader :projects
    # @return [Resources::Clients] Recurso para listar clientes.
    attr_reader :clients
    # @return [Resources::Units] Recurso para listar unidades de un proyecto.
    attr_reader :units

    # Crea un cliente. La configuración se resuelve en este orden:
    # 1. El objeto +configuration+ si se pasa.
    # 2. Una nueva {Configuration} con +access_token+ (y opcionalmente +environment+).
    # 3. La configuración global de {SperantApi.configure} (si existe).
    #
    # @param configuration [Configuration, nil] Configuración ya construida (opcional).
    # @param access_token [String, nil] Token API (opcional si hay configuración global o +configuration+).
    # @param environment [Symbol, nil] +:test+ o +:production+ (solo se usa si se pasa +access_token+).
    # @return [Client]
    # @raise [ConfigurationError] Si no hay configuración ni token ni configuración global.
    #
    # @example Con configuración global
    #   SperantApi.configure { |c| c.access_token = "token"; c.environment = :test }
    #   client = SperantApi::Client.new
    #
    # @example Con parámetros explícitos
    #   client = SperantApi::Client.new(access_token: "token", environment: :production)
    def initialize(configuration: nil, access_token: nil, environment: nil)
      @configuration = resolve_configuration(
        configuration: configuration,
        access_token: access_token,
        environment: environment
      )
      conn = Connection.new(configuration: @configuration)
      @projects = Resources::Projects.new(connection: conn)
      @clients = Resources::Clients.new(connection: conn)
      @units = Resources::Units.new(connection: conn)
    end

    private

    def resolve_configuration(configuration:, access_token:, environment:)
      return configuration if configuration

      if access_token
        opts = { access_token: access_token }
        opts[:environment] = environment if environment
        return Configuration.new(**opts)
      end

      SperantApi.configuration || raise(ConfigurationError, "No configuration. Set SperantApi.configure { ... } or pass access_token:")
    end
  end
end
