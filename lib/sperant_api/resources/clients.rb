# frozen_string_literal: true

module SperantApi
  module Resources
    class Clients < Base
      def list(q: nil, page: nil)
        query = { q: q, page: page }.compact
        get_list(Constants::PATH_CLIENTS, query)
      end
    end
  end
end
