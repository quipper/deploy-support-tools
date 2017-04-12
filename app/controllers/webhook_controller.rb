class WebhookController < ApplicationController
  # Handle webhook request from GitHub
  def receive
    # Respond to ping request
    unless request.headers['X-GitHub-Event'] == 'pull_request'
      render status: 200, text: "ok"
      return
    end

    webhook = JSON.parse(params[:payload]) rescue {}
    repo_name = webhook.dig('pull_request', 'base', 'repo', 'full_name')
    repo_config = RepoConfig.find_by_repo_name(repo_name)

    if repo_config
      action = webhook['action']
      branch = webhook.dig('pull_request', 'head', 'ref')

      if action == 'closed' && branch
        app = App.new repo_config.app_prefix, repo_config.max_entries
        app.remove(branch)
        app.save
      end
    end

    render status: 200, text: "ok"
  end
end
