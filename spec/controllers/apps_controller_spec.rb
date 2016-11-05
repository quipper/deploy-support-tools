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
    let(:store) { ActiveSupport::Cache::MemoryStore.new }

    before do
      allow(Rails).to receive(:cache) { store }
    end

    context 'without repo_name' do
      before do
        post :create, app: "foo", branch: "feature-bar"
      end

      it "responds successfully with an HTTP 200 status code and app name" do
        expect(response).to be_success
        expect(response.body).to eql("foo-staging-1")
      end
    end

    context 'with repo_name' do
      before do
        post :create, app: "foo", branch: "feature-bar", servers: 10, repo_name: "quipper/foo"
      end

      it "responds successfully with an HTTP 200 status code and app name" do
        expect(response).to be_success
        expect(response.body).to eql("foo-staging-1")
      end

      it "persists repo config into Rails.cache" do
        expect(store.read("#{RepoConfig::CACHE_KEY_PREFIX}-quipper/foo")).to eq({app_prefix: 'foo', max_entries: 10})
      end
    end
  end
end
