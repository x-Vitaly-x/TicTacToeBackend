Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  get 'self', to: 'players#self'
  put 'games/:id/make_move', to: 'games#make_move'
  resources :games, :players
end
