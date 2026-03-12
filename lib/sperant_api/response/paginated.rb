# frozen_string_literal: true

module SperantApi
  module Response
    # Respuesta paginada de los métodos +list+ de los recursos.
    # Encapsula +data+, +meta+ y +links+ para no depender de hashes con keys literales.
    class Paginated
      # @return [Array<Hash>] Lista de ítems (proyectos, clientes o unidades).
      attr_reader :data
      # @return [Hash] Metadatos de la API (p. ej. +"page" => { "total" => 5 }+).
      attr_reader :meta
      # @return [Hash] Enlaces de paginación (+prev+, +next+, +last+, etc.).
      attr_reader :links

      # @param data [Array] Array de ítems.
      # @param meta [Hash] Metadatos.
      # @param links [Hash] Enlaces de paginación.
      def initialize(data:, meta: {}, links: {})
        @data = data
        @meta = meta
        @links = links
      end

      # Número total de páginas según la API.
      # @return [Integer, nil] Valor de +meta["page"]["total"]+ o nil si no está presente.
      def total_pages
        meta.dig("page", "total")
      end
    end
  end
end
