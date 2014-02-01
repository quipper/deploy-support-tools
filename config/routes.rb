GetStagingServerName::Application.routes.draw do
  root to: "apps#index"
  resources :apps, only: [:create]
end
