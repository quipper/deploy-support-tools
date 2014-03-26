require "spec_helper"

describe App do
  let(:apps) { ["sputnik", "vostok", "salyut"] }
  let(:sputnik) {
    [
      {"branch_name" => "sputnik-1", "last_use" => "1957-10-04T19:18:34+00:00"},
      {"branch_name" => "sputnik-2/laika", "last_use" => "1957-11-03T02:30:00+00:00"},
    ]
  }
  let(:vostok) {
    [
      {"branch_name" => "vostok-1/yuri-gagarin", "last_use" => "1961-04-12T06:07:00+00:00"},
      {"branch_name" => "vostok-6/valentina-tereshkova", "last_use" => "1963-06-16T09:29:52+00:00"},
    ]
  }
  let(:voskhod) {
    [
      {"branch_name" => "voskhod-1", "last_use" => "1964-10-12T07:30:01+00:00"},
    ]
  }
  let(:salyut) {
    [
      {"branch_name" => "salyut-1", "last_use" => "1971-04-19T01:40:00+00:00"},
    ]
  }

  before do
    Rails.cache.write("apps", apps)
    Rails.cache.write("app-sputnik", sputnik)
    Rails.cache.write("app-vostok", vostok)
    Rails.cache.write("app-salyut", salyut)
  end

  describe ".index" do
    it "returns formatted data" do
      data = App.index
      expect(data).to eq [
        { name: "sputnik", servers: sputnik },
        { name: "vostok", servers: vostok },
        { name: "salyut", servers: salyut },
      ]
    end
  end

  describe ".create" do
    it "returns app name and app number" do
      app, app_number = App.create({ "app" => "voskhod", "branch" => "voskhod-1" })

      expect(app).to eq "voskhod"
      expect(app_number).to be_an Integer
    end

    context 'if params["app"] is not set' do
      it "raises error" do
        expect {
          App.create({ "branch" => "sputnik-1" })
        }.to raise_error
      end
    end

    context 'if params["branch"] is not set' do
      it "raises error" do
        expect {
          App.create({ "app" => "sputnik" })
        }.to raise_error
      end
    end

    context 'if params["servers"] is not set' do
      it {
        pending "no way to test default value is set in complex singleton method."
      }
    end

    context "if number of servers is decreased" do
      pending
    end

    context "if given app is not exist" do
      it "adds given app name to the fleet" do
        expect {
          App.create({ "app" => "voskhod", "branch" => "voskhod-1" })
        }.to change { Rails.cache.read("apps").size }.by(1)
      end
    end

    context "if given branch is found" do
      before do
        Rails.cache.write("app-voskhod", voskhod)
      end

      it "updates last_use" do
        expect {
          App.create({ "app" => "voskhod", "branch" => "voskhod-1" })
        }.to change { Rails.cache.read("app-voskhod")[0]["last_use"] }
      end
    end

    context "if given branch is not found but space available" do
      before do
        Rails.cache.write("app-voskhod", voskhod)
      end

      it "adds new branch" do
        App.create({ "app" => "voskhod", "branch" => "voskhod-2" })

        data = Rails.cache.read("app-voskhod")

        expect(
          data[0]["branch_name"]
        ).to eq "voskhod-1"

        expect(
          data[1]["branch_name"]
        ).to eq "voskhod-2"
      end
    end

    context "if given branch is not found but no space available" do
      it "recycles old app" do
        App.create({ "app" => "sputnik", "branch" => "sputnik-3", "servers" => "2" })

        data = Rails.cache.read("app-sputnik")

        expect(
          data[0]["branch_name"]
        ).to_not eq "sputnik-1"

        expect(
          data[1]["branch_name"]
        ).to eq "sputnik-2/laika"

        expect(
          data[0]["branch_name"]
        ).to eq "sputnik-3"
      end
    end
  end
end
