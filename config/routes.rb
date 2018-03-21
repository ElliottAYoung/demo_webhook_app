Rails.application.routes.draw do
  get '/events' => 'events#index', as: 'events'
  post '/api/events' => 'events#create', as: 'event'
end
