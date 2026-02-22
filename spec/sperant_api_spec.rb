# frozen_string_literal: true

RSpec.describe SperantApi do
  it "has a version number" do
    expect(SperantApi::VERSION).not_to be nil
  end

  describe ".configure" do
    after { SperantApi.configuration = nil }

    it "yields a Configuration and allows setting attributes" do
      SperantApi.configure do |c|
        c.access_token = "token"
        c.environment = :test
      end
      expect(SperantApi.configuration.access_token).to eq("token")
      expect(SperantApi.configuration.environment).to eq(:test)
    end

    it "returns the configuration" do
      config = SperantApi.configure { |c| c.access_token = "t"; c.environment = :test }
      expect(config).to eq(SperantApi.configuration)
    end
  end
end
