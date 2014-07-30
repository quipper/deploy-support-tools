require "spec_helper"

describe Deployment do
  let(:deployment_params) do
    {
      token: "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
      user: "test",
      repo: "test",
      ref: "topic-branch",
      environment: "staging",
      state: "success",
      target_url: "http://example.com/",
    }
  end

  let(:deployment) { Deployment.new(deployment_params) }

  describe "#create_deployment" do
    before do
      res = double
      expect(res).to receive(:content) { File.read("#{Rails.root}/spec/fixtures/github_deployments_api_response.json") }
      expect(deployment.client).to receive(:post) { res }
    end

    it "sends POST request" do
      deployment.create_deployment
      expect(deployment.github_deployments_api_status_url).to eq("https://api.github.com/repos/octocat/example/deployments/1/statuses")
    end
  end

  describe "#create_deployment_status" do
    before do
      deployment.github_deployments_api_status_url = "https://api.github.com/repos/octocat/example/deployments/1/statuses"
      expect(deployment.client).to receive(:post) { |url|
        expect(url).to eq("https://api.github.com/repos/octocat/example/deployments/1/statuses")
      }
    end

    it "sends POST request" do
      deployment.create_deployment_status
    end
  end
end
