# frozen_string_literal: true

RSpec.describe SperantApi::Resources::Clients do
  let(:configuration) do
    SperantApi::Configuration.new(access_token: "token", environment: :test)
  end
  let(:connection) { SperantApi::Connection.new(configuration: configuration) }
  let(:resource) { described_class.new(connection: connection) }

  let(:base_url) { "#{SperantApi::Constants::BASE_URLS[:test]}/#{SperantApi::Constants::API_VERSION}" }

  describe "#list" do
    it "requests GET /clients and returns Paginated response" do
      stub_request(:get, "#{base_url}/#{SperantApi::Constants::PATH_CLIENTS}")
        .to_return(status: 200, body: '{"data":[],"meta":{"page":{"total":0}},"links":{}}', headers: { "Content-Type" => "application/json" })

      response = resource.list

      expect(response).to be_a(SperantApi::Response::Paginated)
      expect(response.data).to eq([])
    end

    it "passes q and page as query params" do
      stub = stub_request(:get, "#{base_url}/#{SperantApi::Constants::PATH_CLIENTS}")
        .with(query: { "q" => "+51999", "page" => "1" })
        .to_return(status: 200, body: '{"data":[],"meta":{},"links":{}}', headers: { "Content-Type" => "application/json" })

      resource.list(q: "+51999", page: 1)

      expect(stub).to have_been_requested
    end
  end

  describe "#find" do
    it "requests GET /clients/:id and returns the client data" do
      client_id = 123
      body = { "data" => { "id" => client_id, "name" => "Cliente Ejemplo" } }
      stub_request(:get, "#{base_url}/#{SperantApi::Constants::PATH_CLIENTS}/#{client_id}")
        .to_return(status: 200, body: body.to_json, headers: { "Content-Type" => "application/json" })

      result = resource.find(client_id)

      expect(result).to eq("id" => client_id, "name" => "Cliente Ejemplo")
    end
  end
end
