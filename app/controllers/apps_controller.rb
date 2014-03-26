class AppsController < ApplicationController
  http_basic_authenticate_with name: ENV["AUTH_USER"], password: ENV["AUTH_PASSWORD"], except: :create

  def index
    json = App.index
    render json: json
  end

  def create
    app, app_number = App.create(params)
    render text: "#{app}-staging-#{app_number}"
  end
end
