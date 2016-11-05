require "spec_helper"

describe AppsController do
  describe '#index' do
    before do
      http_login
    end

    context "format: :html" do
      it "renders HTML" do
        get :index
        expect(response).to be_success
        expect(response).to render_template("index")
        expect(response.headers['Content-Type']).to match('text/html')
      end
    end

    context "format: :json" do
      it "renders JSON" do
        get :index, {format: :json}
        expect(response).to be_success
        expect(response).to render_template("index")
        expect(response.headers['Content-Type']).to match('application/json')
      end
    end
  end

  describe "#create" do
    it "responds successfully with an HTTP 200 status code and app name" do
      post :create, app: "foo", branch: "feature-bar"
      expect(response).to be_success
      expect(response.body).to eql("foo-staging-1")
    end
  end
end
