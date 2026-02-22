# frozen_string_literal: true

RSpec.describe SperantApi::Resources::Projects do
  let(:configuration) do
    SperantApi::Configuration.new(access_token: "token", environment: :test)
  end
  let(:connection) { SperantApi::Connection.new(configuration: configuration) }
  let(:resource) { described_class.new(connection: connection) }

  let(:base_url) { "#{SperantApi::Constants::BASE_URLS[:test]}/#{SperantApi::Constants::API_VERSION}" }

  describe "#list" do
    it "requests GET /projects and returns Paginated response" do
      stub_request(:get, "#{base_url}/#{SperantApi::Constants::PATH_PROJECTS}")
        .to_return(status: 200, body: '{"data":[{"id":"1"}],"meta":{"page":{"total":1}},"links":{}}', headers: { "Content-Type" => "application/json" })

      response = resource.list

      expect(response).to be_a(SperantApi::Response::Paginated)
      expect(response.data).to eq([{ "id" => "1" }])
      expect(response.total_pages).to eq(1)
    end

    it "passes code, q, page as query params" do
      stub = stub_request(:get, "#{base_url}/#{SperantApi::Constants::PATH_PROJECTS}")
        .with(query: { "code" => "PRADOS", "q" => "Prados", "page" => "2" })
        .to_return(status: 200, body: '{"data":[],"meta":{},"links":{}}', headers: { "Content-Type" => "application/json" })

      resource.list(code: "PRADOS", q: "Prados", page: 2)

      expect(stub).to have_been_requested
    end
  end
end
