HerokuSupportTools::Application.routes.draw do
  root to: "apps#index"
  resources :apps, only: [:index, :create]
end
