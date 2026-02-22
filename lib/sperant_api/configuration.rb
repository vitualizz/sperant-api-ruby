# frozen_string_literal: true

module SperantApi
  class Configuration
    attr_accessor :access_token, :environment, :page_size

    def initialize(access_token: nil, environment: Constants::ENVIRONMENTS.first, page_size: Constants::DEFAULT_PAGE_SIZE)
      @access_token = access_token
      @environment = environment.to_sym
      @page_size = page_size
      validate_environment!
      validate_token! if access_token
    end

    def environment=(value)
      @environment = value.to_sym
      validate_environment!
    end

    def access_token=(value)
      @access_token = value
      validate_token!
    end

    def base_url
      base = Constants::BASE_URLS[environment]
      raise ConfigurationError, "Unknown environment: #{environment}" unless base

      base
    end

    def validate!
      validate_token!
      validate_environment!
    end

    private

    def validate_token!
      token = access_token.to_s.strip
      raise ConfigurationError, "access_token is required" if token.empty?
    end

    def validate_environment!
      return if Constants::ENVIRONMENTS.include?(environment)

      raise ConfigurationError,
            "Invalid environment: #{environment}. Must be one of: #{Constants::ENVIRONMENTS.join(', ')}"
    end
  end
end
