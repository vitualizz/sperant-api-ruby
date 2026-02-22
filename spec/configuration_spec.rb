# frozen_string_literal: true

RSpec.describe SperantApi::Configuration do
  describe "#initialize" do
    it "accepts access_token and environment" do
      config = described_class.new(access_token: "secret", environment: :test)
      expect(config.access_token).to eq("secret")
      expect(config.environment).to eq(:test)
    end

    it "defaults environment to test" do
      config = described_class.new(access_token: "x")
      expect(config.environment).to eq(:test)
    end

    it "raises ConfigurationError when access_token is empty" do
      expect { described_class.new(access_token: "") }.to raise_error(SperantApi::ConfigurationError, /access_token is required/)
      expect { described_class.new(access_token: "   ") }.to raise_error(SperantApi::ConfigurationError, /access_token is required/)
    end

    it "raises ConfigurationError when environment is invalid" do
      expect { described_class.new(access_token: "x", environment: :staging) }.to raise_error(SperantApi::ConfigurationError, /Invalid environment/)
    end

    it "allows initialization without token for global config" do
      config = described_class.new
      expect(config.environment).to eq(:test)
    end
  end

  describe "#base_url" do
    it "returns test base URL for :test" do
      config = described_class.new(access_token: "x", environment: :test)
      expect(config.base_url).to eq(SperantApi::Constants::BASE_URLS[:test])
    end

    it "returns production base URL for :production" do
      config = described_class.new(access_token: "x", environment: :production)
      expect(config.base_url).to eq(SperantApi::Constants::BASE_URLS[:production])
    end
  end

  describe "#validate!" do
    it "raises when token is missing" do
      config = described_class.new
      expect { config.validate! }.to raise_error(SperantApi::ConfigurationError, /access_token is required/)
    end

    it "does not raise when token is set" do
      config = described_class.new(access_token: "x")
      expect { config.validate! }.not_to raise_error
    end
  end
end
