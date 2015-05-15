class AppsController < ApplicationController
  http_basic_authenticate_with name: ENV["AUTH_USER"], password: ENV["AUTH_PASSWORD"], except: [:create, :staging_url]

  APPS_KEY = "apps"

  def index
    @apps = Rails.cache.read(APPS_KEY) || []
  end

  def create
    app = params["app"] || raise("app is not set")
    branch = params["branch"] || raise("branch is not set")
    servers = (params["servers"] || 4).to_i

    apps = Rails.cache.read(APPS_KEY) || []
    apps << app
    apps = apps.sort.uniq
    Rails.cache.write(APPS_KEY, apps)

    kiosk = App.new app, servers
    app_number = kiosk.lottery branch
    kiosk.save

    render text: "#{app}-staging-#{app_number}"
  end

  def staging_url
    render json: { text: StagingUrl.new(params[:text]).to_s }
  end
end
