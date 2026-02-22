# frozen_string_literal: true

RSpec.describe SperantApi::Connection do
  let(:configuration) do
    SperantApi::Configuration.new(access_token: "test-token", environment: :test)
  end
  let(:connection) { described_class.new(configuration: configuration) }

  let(:base_url) { "#{SperantApi::Constants::BASE_URLS[:test]}/#{SperantApi::Constants::API_VERSION}" }

  describe "#get" do
    it "sends GET with Authorization header and returns parsed JSON" do
      stub = stub_request(:get, "#{base_url}/projects")
        .with(headers: { SperantApi::Constants::HEADER_AUTHORIZATION => "test-token" })
        .to_return(status: 200, body: '{"data":[],"meta":{},"links":{}}', headers: { "Content-Type" => "application/json" })

      result = connection.get("projects")

      expect(stub).to have_been_requested
      expect(result).to eq("data" => [], "meta" => {}, "links" => {})
    end

    it "includes query params in the request" do
      stub = stub_request(:get, "#{base_url}/projects")
        .with(query: { "page" => "2", "q" => "Prados" })
        .to_return(status: 200, body: '{"data":[]}', headers: { "Content-Type" => "application/json" })

      connection.get("projects", { page: 2, q: "Prados" })

      expect(stub).to have_been_requested
    end

    it "raises ApiError on 4xx" do
      stub_request(:get, "#{base_url}/projects")
        .to_return(status: 401, body: "Unauthorized")

      expect { connection.get("projects") }.to raise_error(SperantApi::ApiError) do |e|
        expect(e.status_code).to eq(401)
        expect(e.response_body).to eq("Unauthorized")
      end
    end

    it "raises RateLimitError on 429" do
      stub_request(:get, "#{base_url}/projects")
        .to_return(status: 429, body: "Too Many Requests")

      expect { connection.get("projects") }.to raise_error(SperantApi::RateLimitError) do |e|
        expect(e.status_code).to eq(429)
      end
    end

    it "validates configuration before request" do
      config = SperantApi::Configuration.new
      conn = described_class.new(configuration: config)
      expect { conn.get("projects") }.to raise_error(SperantApi::ConfigurationError, /access_token is required/)
    end
  end
end
