module AppsHelper
  def staging_url_for_app(app, number)
    # e.g. DEPLOY_SUPPORT_TOOL_STAGING_URL_FORMAT="https://%s-staging-%d.herokuapp.com/"
    if format = ENV['DEPLOY_SUPPORT_TOOL_STAGING_URL_FORMAT']
      format % [app, number]
    else
      "#{app}:#{number}"
    end
  end
end
