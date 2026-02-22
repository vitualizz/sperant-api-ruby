# frozen_string_literal: true

require "net/http"
require "json"
require "uri"

module SperantApi
  class Connection
    attr_reader :configuration, :adapter

    def initialize(configuration:, adapter: nil)
      @configuration = configuration
      @adapter = adapter
    end

    def get(path, query_params = {})
      configuration.validate!
      uri = build_uri(path, query_params)
      request = build_request(uri)
      response = perform_request(uri, request)
      handle_response(response)
    end

    private

    def build_uri(path, query_params)
      path = path.join("/") if path.is_a?(Array)
      base = configuration.base_url
      version = Constants::API_VERSION
      path_part = [version, path].join("/").gsub(%r{/+}, "/")
      base_uri = URI.parse(base)
      query_string = query_params.any? { |_, v| !v.nil? && v != "" } ? URI.encode_www_form(query_params.compact) : nil
      URI::HTTPS.build(host: base_uri.host, port: base_uri.port, path: "/#{path_part}", query: query_string)
    end

    def build_request(uri)
      request = Net::HTTP::Get.new(uri.request_uri)
      request[Constants::HEADER_AUTHORIZATION] = configuration.access_token
      request["Content-Type"] = "application/json"
      request["Accept"] = "application/json"
      request
    end

    def perform_request(uri, request)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = (uri.scheme == "https")
      http.request(request)
    end

    def handle_response(response)
      status = response.code.to_i
      body = response.body.to_s

      case status
      when 200..299
        body.empty? ? {} : JSON.parse(body)
      when Constants::HTTP_STATUS_RATE_LIMIT
        raise RateLimitError.new(response_body: body)
      when 400..599
        raise ApiError.new(
          "Request failed with status #{response.code}",
          status_code: status,
          response_body: body
        )
      else
        body.empty? ? {} : JSON.parse(body)
      end
    end
  end
end
