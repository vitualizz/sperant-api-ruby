# frozen_string_literal: true

module SperantApi
  module Resources
    # Recurso de unidades. Lista unidades de un proyecto (y opcionalmente por bloque o estado comercial).
    class Units < Base
      # Lista unidades de un proyecto (paginado).
      #
      # @param project_id [Integer] ID del proyecto.
      # @param block_id [Integer, nil] ID de subdivisión/bloque (opcional).
      # @param commercial_status_id [Integer, nil] Estado comercial (ej. 1=Disponible, 2=No disponible) (opcional).
      # @param page [Integer, nil] Número de página.
      # @return [Response::Paginated] Respuesta con +data+, +meta+, +links+ y +total_pages+.
      #
      # @example
      #   response = client.units.list(project_id: 7)
      #   response = client.units.list(project_id: 7, commercial_status_id: 1, page: 2)
      def list(project_id:, block_id: nil, commercial_status_id: nil, page: nil)
        path = [Constants::PATH_PROJECTS, project_id, Constants::PATH_UNITS]
        query = { block_id: block_id, commercial_status_id: commercial_status_id, page: page }.compact
        get_list(path, query)
      end
    end
  end
end
