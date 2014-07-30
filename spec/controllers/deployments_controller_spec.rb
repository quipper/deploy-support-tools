require 'spec_helper'

describe DeploymentsController do
  describe "create" do
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

    before do
      deployment = double
      expect(deployment).to receive(:perform)
      expect(Deployment).to receive(:new) { deployment }
      allow(@controller).to receive(:render)
    end

    it "performs new deployment" do
      post :create, deployment_params
    end
  end
end
