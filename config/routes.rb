Rails.application.routes.draw do
  namespace :v1 do
    post '/login' => 'authentication#create'

    resources :posts
  end
end
