class DeploymentsController < ApplicationController
  def create
    if deployment_params.present?
      deployment = Deployment.new(deployment_params)
      deployment.perform
      render json: deployment
    end
  end

  private

  def deployment_params
    params.slice(:token, :user, :repo, :ref, :environment, :state, :target_url)
  end
end
