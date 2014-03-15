class AppsController < ApplicationController

  APPS_KEY = "apps"

  def index
    apps = Rails.cache.read(APPS_KEY) || []
    json = apps.map do |app|
      {name: app, servers: Rails.cache.read("app-#{app}")}
    end
    render json: json
  end

  def create
    app = params["app"] || raise("app is not set")
    branch = params["branch"] || raise("branch is not set")
    servers = (params["servers"] || 4).to_i

    apps = Rails.cache.read(APPS_KEY) || []
    apps << app
    apps = apps.sort.uniq
    Rails.cache.write(APPS_KEY, apps)

    cache_key = "app-#{app}"
    keys = Rails.cache.read(cache_key) || []

    # keys structure
    # [{"branch_name": "feacher-foo",
    #   "last_use": <timestamp>},
    #  {"branch_name": "feacher-bar",
    #   "last_use": <timestamp>}]

    keys = keys[0..(servers-1)] # when number of servers is decreased

    if index = keys.index{|key| key["branch_name"] == branch }
      # found
      app_number = index + 1
      keys[index]["last_use"] = Time.now
    elsif keys.length < servers
      # space available
      keys << {"branch_name" => branch,
        "last_use" => Time.now}
      app_number = keys.length
    else
      # no space available. recycle
      oldest = keys.sort{|a, b| a["last_use"] <=> b["last_use"]}.first
      index = keys.index(oldest)
      app_number = index + 1
      keys[index]["branch_name"] = branch
      keys[index]["last_use"] = Time.now
    end

    keys = Rails.cache.write(cache_key, keys)
    render text: "#{app}-staging-#{app_number}"
  end
end
