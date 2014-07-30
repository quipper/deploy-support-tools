class Deployment
  attr_accessor :token, :user, :repo, :ref, :environment, :state, :target_url, :github_deployments_api_status_url

  def initialize(deployment_params)
    @token       = ENV["GITHUB_API_TOKEN"]
    @user        = deployment_params[:user]
    @repo        = deployment_params[:repo]
    @ref         = deployment_params[:ref]
    @environment = deployment_params[:environment]
    @state       = deployment_params[:state]
    @target_url  = deployment_params[:target_url]
  end

  def perform
    create_deployment
    create_deployment_status
  end

  def client
    @client ||= HTTPClient.new
  end

  def create_deployment
    @last_response = client.post github_deployments_api_url, {ref: ref, auto_merge: false, required_contexts: [], environment: environment}.to_json, github_deployments_api_extra_headers
    self.github_deployments_api_status_url = JSON.parse(@last_response.content)["statuses_url"]
  end

  def create_deployment_status
    @last_response = client.post github_deployments_api_status_url, {state: state, target_url: target_url}.to_json, github_deployments_api_extra_headers
  end

  def github_deployments_api_url
    "https://api.github.com/repos/#{user}/#{repo}/deployments"
  end

  def github_deployments_api_extra_headers
    [["Accept", "application/vnd.github.cannonball-preview+json"], ["Authorization", "token #{token}"]]
  end

  def to_json(options)
    @last_response.content
  end
end
