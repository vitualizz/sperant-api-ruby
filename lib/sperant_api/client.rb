# frozen_string_literal: true

module SperantApi
  class Client
    attr_reader :configuration, :projects, :clients, :units

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
