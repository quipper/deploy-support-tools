require "spec_helper"

describe AppsController do
  describe "Find or create app name" do

    it "responds successfully with an HTTP 200 status code" do
      post :create, app: "foo", branch: "feature-bar"
      expect(response).to be_success
      expect(response.body).to eql("quipper-foo-staging-1")
    end
  end
end
