module AppsHelper
  def staging_url_for_app(app, number)
    # e.g. DEPLOY_SUPPORT_TOOL_STAGING_URL_FORMAT="https://%s-staging-%d.herokuapp.com/"
    if format = ENV['DEPLOY_SUPPORT_TOOL_STAGING_URL_FORMAT']
      ignoring_prefixes = ENV['DEPLOY_SUPPORT_TOOL_STAGING_URL_OF_IGNORING_PREFIXES']
      return format % [app, number] unless ignoring_prefixes
      match = app.match(/(\A(#{ignoring_prefixes.split(',').join('|')})\-)?(?<app_name_without_prefix>(.+))/)
      format % [match[:app_name_without_prefix], number]
    else
      "#{app}:#{number}"
    end
  end
end
