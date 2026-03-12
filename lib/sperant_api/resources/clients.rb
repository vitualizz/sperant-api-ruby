# frozen_string_literal: true

module SperantApi
  module Resources
    # Recurso de clientes. Permite listar clientes con filtros opcionales.
    class Clients < Base
      # Lista clientes (paginado). El parámetro +q+ filtra por documento, email o celular (con código de país).
      #
      # @param q [String, nil] Búsqueda (ej. "+51999..." para celular).
      # @param page [Integer, nil] Número de página.
      # @return [Response::Paginated] Respuesta con +data+, +meta+, +links+ y +total_pages+.
      #
      # @example
      #   response = client.clients.list
      #   response = client.clients.list(q: "+51999123456")
      def list(q: nil, page: nil)
        query = { q: q, page: page }.compact
        get_list(Constants::PATH_CLIENTS, query)
      end
    end
  end
end
