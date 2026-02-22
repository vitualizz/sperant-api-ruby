# frozen_string_literal: true

require_relative "sperant_api/version"
require_relative "sperant_api/constants"
require_relative "sperant_api/errors"
require_relative "sperant_api/configuration"
require_relative "sperant_api/connection"
require_relative "sperant_api/response/paginated"
require_relative "sperant_api/resources/base"
require_relative "sperant_api/resources/projects"
require_relative "sperant_api/resources/clients"
require_relative "sperant_api/resources/units"
require_relative "sperant_api/client"

module SperantApi
  class << self
    attr_accessor :configuration

    def configure
      self.configuration ||= Configuration.new
      yield(configuration) if block_given?
      configuration
    end
  end
end
