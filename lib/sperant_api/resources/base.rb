# frozen_string_literal: true

module SperantApi
  module Resources
    # Clase base para recursos que exponen listados paginados.
    # Las subclases definen +list+ y usan {#get_list} con el path y parámetros adecuados.
    class Base
      # @return [Connection] Conexión HTTP usada para las peticiones.
      attr_reader :connection

      # @param connection [Connection] Conexión ya configurada.
      def initialize(connection:)
        @connection = connection
      end

      protected

      # Realiza GET al path y devuelve una respuesta paginada.
      # @param path [String, Array<String>] Segmentos del path (se unen con +/+).
      # @param query_params [Hash] Parámetros de consulta.
      # @return [Response::Paginated]
      def get_list(path, query_params = {})
        path = Array(path).join("/")
        raw = connection.get(path, query_params)
        build_paginated_response(raw)
      end

      # Realiza GET al path y devuelve el cuerpo de la respuesta (hash parseado).
      # @param path [String, Array<String>] Segmentos del path (se unen con +/+).
      # @return [Hash] Respuesta cruda de la API (suele incluir +data+ para un recurso).
      def get_one(path)
        path = Array(path).join("/")
        connection.get(path)
      end

      def build_paginated_response(raw)
        Response::Paginated.new(
          data: raw["data"] || [],
          meta: raw["meta"] || {},
          links: raw["links"] || {}
        )
      end
    end
  end
end
