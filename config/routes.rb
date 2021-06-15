Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  get 'self', to: 'players#self'
  get 'test', to: 'games#test'
  resources :games, :players
end
