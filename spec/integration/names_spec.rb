require "spec_helper"

describe AppsController do
  describe "Find or create app name" do

    it "responds successfully with an HTTP 200 status code" do
      post "/apps", app: "foo", branch: "feature-bar", servers: 2
      expect(response).to be_success
      expect(response.body).to eql("quipper-foo-staging-1")

      # same branch
      post "/apps", app: "foo", branch: "feature-bar", servers: 2
      expect(response).to be_success
      expect(response.body).to eql("quipper-foo-staging-1")

      # other branch
      post "/apps", app: "foo", branch: "feature-baz", servers: 2
      expect(response).to be_success
      expect(response.body).to eql("quipper-foo-staging-2")

      # the first branch again
      post "/apps", app: "foo", branch: "feature-bar", servers: 2
      expect(response).to be_success
      expect(response.body).to eql("quipper-foo-staging-1")

      # another branch
      post "/apps", app: "foo", branch: "feature-foo", servers: 2
      expect(response).to be_success
      expect(response.body).to eql("quipper-foo-staging-2")

      # incresed server
      post "/apps", app: "foo", branch: "feature-zzz", servers: 3
      expect(response).to be_success
      expect(response.body).to eql("quipper-foo-staging-3")

      # reduced server
      Timecop.freeze do
        post "/apps", app: "foo", branch: "feature-zzz", servers: 1
        expect(response).to be_success
        expect(response.body).to eql("quipper-foo-staging-1")

        post "/apps", app: "bar", branch: "feature-xxx", servers: 1
        expect(response).to be_success
        expect(response.body).to eql("quipper-bar-staging-1")

        get "/apps"
        expect(response).to be_success
        expect(JSON.parse(response.body)).to eql([{"name" => "bar",
                                                   "servers" =>
                                                     [{"branch_name" => "feature-xxx",
                                                       "last_use" => Time.now.as_json}]},
                                                  {"name" => "foo",
                                                   "servers" =>
                                                     [{"branch_name" => "feature-zzz",
                                                       "last_use" => Time.now.as_json}]}])
      end
    end
  end
end
