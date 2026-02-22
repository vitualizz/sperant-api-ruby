# frozen_string_literal: true

module SperantApi
  module Response
    class Paginated
      attr_reader :data, :meta, :links

      def initialize(data:, meta: {}, links: {})
        @data = data
        @meta = meta
        @links = links
      end

      def total_pages
        meta.dig("page", "total")
      end
    end
  end
end
