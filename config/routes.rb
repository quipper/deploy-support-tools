HerokuSupportTools::Application.routes.draw do
  root to: "apps#index"
  resources :apps, only: [:index, :create] do
    collection do
      post :staging_url
    end
  end
  get '/scripts/production_deploy.sh(.:format)', to: 'scripts#production_deploy'
  get '/scripts/staging_deploy.sh(.:format)', to: 'scripts#staging_deploy'
  get '/scripts/v2/production_deploy.sh(.:format)', to: 'scripts#production_deploy_v2'
  get '/scripts/v2/staging_deploy.sh(.:format)', to: 'scripts#staging_deploy_v2'

  resources :deployments, only: [:create]
  post '/webhook' => 'webhook#receive'
end
