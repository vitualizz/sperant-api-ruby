# frozen_string_literal: true

module SperantApi
  module Constants
    ENVIRONMENTS = %i[test production].freeze

    BASE_URLS = {
      test: "https://api.eterniasoft.com",
      production: "https://api.sperant.com"
    }.freeze

    API_VERSION = "v3"
    DEFAULT_PAGE_SIZE = 20

    HEADER_AUTHORIZATION = "Authorization"

    PATH_PROJECTS = "projects"
    PATH_CLIENTS = "clients"
    PATH_UNITS = "units"

    HTTP_STATUS_RATE_LIMIT = 429
  end
end
