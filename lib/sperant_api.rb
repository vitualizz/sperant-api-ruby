# frozen_string_literal: true

require_relative "sperant_api/version"
require_relative "sperant_api/constants"
require_relative "sperant_api/errors"
require_relative "sperant_api/configuration"
require_relative "sperant_api/connection"
require_relative "sperant_api/response/paginated"
require_relative "sperant_api/resources/base"
require_relative "sperant_api/resources/projects"
require_relative "sperant_api/resources/clients"
require_relative "sperant_api/resources/units"
require_relative "sperant_api/client"

# Cliente Ruby no oficial para la API v3 de Sperant (proyectos, clientes, unidades).
# Configuración por token y entorno (:test o :production).
#
# @example Configuración global y uso del cliente
#   SperantApi.configure do |c|
#     c.access_token = "tu-token"
#     c.environment = :test
#   end
#   client = SperantApi::Client.new
#   client.projects.list(q: "Prados")
#
# @see https://sperant.gitbook.io/apiv3 Documentación oficial de la API
module SperantApi
  class << self
    # @return [Configuration, nil] Configuración global actual (nil hasta llamar a {configure}).
    attr_accessor :configuration

    # Configura la gema de forma global. Crea una instancia de {Configuration} si no existe
    # y permite modificarla mediante el bloque.
    #
    # @yield [configuration] Bloque opcional que recibe la configuración.
    # @yieldparam configuration [Configuration] Objeto de configuración a modificar.
    # @return [Configuration] La configuración resultante.
    #
    # @example
    #   SperantApi.configure do |c|
    #     c.access_token = ENV["SPERANT_API_TOKEN"]
    #     c.environment = :production
    #   end
    def configure
      self.configuration ||= Configuration.new
      yield(configuration) if block_given?
      configuration
    end
  end
end
