# frozen_string_literal: true

module SperantApi
  module Resources
    class Base
      attr_reader :connection

      def initialize(connection:)
        @connection = connection
      end

      protected

      def get_list(path, query_params = {})
        path = Array(path).join("/")
        raw = connection.get(path, query_params)
        build_paginated_response(raw)
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
