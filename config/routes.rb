Rails.application.routes.draw do
  root to: 'api/v1/providers#index', :defaults => { :format => 'json' }
  get '/providers' => 'api/v1/providers#index', :defaults => { :format => 'json' }
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :providers, only: [:index]
    end
  end
end
