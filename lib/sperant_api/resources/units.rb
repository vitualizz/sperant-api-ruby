# frozen_string_literal: true

module SperantApi
  module Resources
    class Units < Base
      def list(project_id:, block_id: nil, commercial_status_id: nil, page: nil)
        path = [Constants::PATH_PROJECTS, project_id, Constants::PATH_UNITS]
        query = { block_id: block_id, commercial_status_id: commercial_status_id, page: page }.compact
        get_list(path, query)
      end
    end
  end
end
