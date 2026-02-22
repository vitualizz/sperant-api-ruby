# frozen_string_literal: true

require_relative "lib/sperant_api/version"

Gem::Specification.new do |spec|
  spec.name = "sperant-api"
  spec.version = SperantApi::VERSION
  spec.authors = ["Eterniasoft"]
  spec.email = [""]

  spec.summary = "Ruby client for Sperant API v3"
  spec.description = "Client gem for Sperant API v3: projects, clients, and units. Configurable token and test/production environment."
  spec.homepage = "https://github.com/eterniasoft/sperant-api-ruby"
  spec.required_ruby_version = ">= 2.7.0"
  spec.licenses = ["MIT"]

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["documentation_uri"] = "https://sperant.gitbook.io/apiv3"

  spec.files = Dir["lib/**/*", "README.md", "LICENSE"]
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "json", "~> 2.0"

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 3.0"
end
