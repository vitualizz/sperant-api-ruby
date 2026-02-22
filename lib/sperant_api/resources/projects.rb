# frozen_string_literal: true

module SperantApi
  module Resources
    class Projects < Base
      def list(code: nil, q: nil, page: nil)
        query = { code: code, q: q, page: page }.compact
        get_list(Constants::PATH_PROJECTS, query)
      end
    end
  end
end
