class StagingUrl
  def initialize(github_pull_request_url, github_api_token: nil, circleci_api_token: nil)
    @github_pull_request_url = github_pull_request_url
    @github_api_token   = github_api_token   || ENV['GITHUB_API_TOKEN']   || raise(ArgumentError.new("GITHUB_API_TOKEN is required."))
    @circleci_api_token = circleci_api_token || ENV['CIRCLECI_API_TOKEN'] || raise(ArgumentError.new("CIRCLECI_API_TOKEN is required."))
    parse
    get_git_branch_name
    get_heroku_url
  end

  def to_s
    "https://#{@heroku_url.sub(/^quipper-/, '')}.quipper.net"
  end

  private

  def parse
    _, @user, @repo, @number = *Addressable::URI.parse(@github_pull_request_url).path.match(%r!\A/([^/]+)/([^/]+)/pull/(\d+)\z!)
  end

  def get_git_branch_name
    @git_branch_name = Octokit::Client.new(access_token: @github_api_token).pull_request("#{@user}/#{@repo}", @number).head.ref
  end

  def get_heroku_url
    # Get latest build of target branch
    conn = Faraday.new(url: "https://circleci.com/")
    response = conn.get do |req|
      req.url "/api/v1/project/#{@user}/#{@repo}/tree/#{@git_branch_name}", limit: 1, filter: 'successful'
      req.params['circle-token'] = @circleci_api_token
    end
    build = JSON.parse(response.body).first

    # Get build step log of staging deploy
    response = conn.get do |req|
      req.url "/api/v1/project/#{@user}/#{@repo}/#{build['build_num']}"
      req.params['circle-token'] = @circleci_api_token
    end
    step = JSON.parse(response.body)['steps'].detect { |step|
      step['name'].match(/staging_deploy\.sh/)
    }
    response = Faraday.get step['actions'][0]['output_url']

    # Extract deployed heroku app name
    @heroku_url = JSON.parse(response.body)[0]['message'].match(/HEROKU_APP_NAME=(\S+)/)[1]
  end
end
