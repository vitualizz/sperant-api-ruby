# frozen_string_literal: true

RSpec.describe SperantApi::Resources::Units do
  let(:configuration) do
    SperantApi::Configuration.new(access_token: "token", environment: :test)
  end
  let(:connection) { SperantApi::Connection.new(configuration: configuration) }
  let(:resource) { described_class.new(connection: connection) }

  let(:base_url) { "#{SperantApi::Constants::BASE_URLS[:test]}/#{SperantApi::Constants::API_VERSION}" }
  let(:project_id) { 7 }

  describe "#list" do
    it "requests GET /projects/:project_id/units and returns Paginated response" do
      path = "#{SperantApi::Constants::PATH_PROJECTS}/#{project_id}/#{SperantApi::Constants::PATH_UNITS}"
      stub_request(:get, "#{base_url}/#{path}")
        .to_return(status: 200, body: '{"data":[],"meta":{},"links":{}}', headers: { "Content-Type" => "application/json" })

      response = resource.list(project_id: project_id)

      expect(response).to be_a(SperantApi::Response::Paginated)
      expect(response.data).to eq([])
    end

    it "passes block_id, commercial_status_id, page as query params" do
      path = "#{SperantApi::Constants::PATH_PROJECTS}/#{project_id}/#{SperantApi::Constants::PATH_UNITS}"
      stub = stub_request(:get, "#{base_url}/#{path}")
        .with(query: { "block_id" => "10", "commercial_status_id" => "1", "page" => "2" })
        .to_return(status: 200, body: '{"data":[],"meta":{},"links":{}}', headers: { "Content-Type" => "application/json" })

      resource.list(project_id: project_id, block_id: 10, commercial_status_id: 1, page: 2)

      expect(stub).to have_been_requested
    end
  end
end
