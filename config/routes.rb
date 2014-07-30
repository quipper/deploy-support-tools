HerokuSupportTools::Application.routes.draw do
  root to: "apps#index"
  resources :apps, only: [:index, :create]
  get '/scripts/production_deploy.sh(.:format)', to: 'scripts#production_deploy'
  get '/scripts/staging_deploy.sh(.:format)', to: 'scripts#staging_deploy'
  post '/notifications/hipchat', to: 'notifications#hipchat'

  resources :deployments, only: [:create]
end
