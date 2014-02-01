require "spec_helper"

describe AppsController do
  describe "Find or create app name" do

    it "responds successfully with an HTTP 200 status code" do
      post "/apps", app: "foo", branch: "feature-bar", servers: 2
      expect(response).to be_success
      expect(response.body).to eql("quipper-staging-1")

      # same branch
      post "/apps", app: "foo", branch: "feature-bar", servers: 2
      expect(response).to be_success
      expect(response.body).to eql("quipper-staging-1")

      # other branch
      post "/apps", app: "foo", branch: "feature-baz", servers: 2
      expect(response).to be_success
      expect(response.body).to eql("quipper-staging-2")

      # the first branch again
      post "/apps", app: "foo", branch: "feature-bar", servers: 2
      expect(response).to be_success
      expect(response.body).to eql("quipper-staging-1")

      # another branch
      post "/apps", app: "foo", branch: "feature-foo", servers: 2
      expect(response).to be_success
      expect(response.body).to eql("quipper-staging-2")

      # incresed server
      post "/apps", app: "foo", branch: "feature-zzz", servers: 3
      expect(response).to be_success
      expect(response.body).to eql("quipper-staging-3")

      # reduced server
      post "/apps", app: "foo", branch: "feature-zzz", servers: 1
      expect(response).to be_success
      expect(response.body).to eql("quipper-staging-1")
    end
  end
end
