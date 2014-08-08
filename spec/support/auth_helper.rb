module AuthHelper
  def http_login
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(ENV['AUTH_USER'], ENV['AUTH_PASSWORD'])
  end

  def http_auth_header
    {
      'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials(ENV["AUTH_USER"], ENV["AUTH_PASSWORD"])
    }
  end
end

RSpec.configure do |config|
  config.include AuthHelper, type: :request
  config.include AuthHelper, type: :controller
end
