require "spec_helper"

describe NotificationsController do
  describe "post /notifications/hipchat" do

    context "with valid params" do
      it "should success and call hipchat API" do
        client = double('client')
        room = double('room')
        allow(HipChat::Client).to receive(:new).and_return(client)
        allow(client).to receive(:[]).with('room').and_return(room)
        allow(room).to receive(:send).with('deploy', "branch is deployed to <a href='http://localhost'>http://localhost</a>")

        post "/notifications/hipchat", token: 'token', room: 'room', branch: 'branch', url: 'http://localhost'
        expect(response.status).to eq 200
      end
    end

    context "invalid params" do
      it "without token responds 400 bad request" do
        post "/notifications/hipchat", room: 'room', branch: 'branch', url: 'http://localhost'
        expect(response.status).to eq 400
      end

      it "without room responds 400 bad request" do
        post "/notifications/hipchat", token: 'token', branch: 'branch', url: 'http://localhost'
        expect(response.status).to eq 400
      end

      it "without branch responds 400 bad request" do
        post "/notifications/hipchat", token: 'token', room: 'room', url: 'http://localhost'
        expect(response.status).to eq 400
      end

      it "without url responds 400 bad request" do
        post "/notifications/hipchat", token: 'token', room: 'room', branch: 'branch'
        expect(response.status).to eq 400
      end
    end
  end
end
