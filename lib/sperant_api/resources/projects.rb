# frozen_string_literal: true

module SperantApi
  module Resources
    # Recurso de proyectos. Permite listar proyectos con filtros opcionales.
    class Projects < Base
      # Lista proyectos (paginado, 20 por página por defecto).
      #
      # @param code [String, nil] Filtrar por código del proyecto.
      # @param q [String, nil] Búsqueda (nombre, código, etc.).
      # @param page [Integer, nil] Número de página.
      # @return [Response::Paginated] Respuesta con +data+, +meta+, +links+ y +total_pages+.
      #
      # @example
      #   response = client.projects.list
      #   response = client.projects.list(q: "Prados", page: 2)
      def list(code: nil, q: nil, page: nil)
        query = { code: code, q: q, page: page }.compact
        get_list(Constants::PATH_PROJECTS, query)
      end

      # Obtiene un proyecto por ID.
      #
      # @param id [Integer, String] ID del proyecto.
      # @return [Hash] Datos del proyecto (contenido de +data+ en la respuesta de la API).
      #
      # @example
      #   project_data = client.projects.find(456)
      def find(id)
        raw = get_one([Constants::PATH_PROJECTS, id])
        raw["data"] || raw
      end
    end
  end
end
