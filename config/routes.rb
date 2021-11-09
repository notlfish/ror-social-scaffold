Rails.application.routes.draw do
  root 'posts#index'

  devise_for :users,
             defaults: { format: :json },
             path: '',
             path_names: {
               sign_in: 'login',
               sign_out: 'logout',
               registration: 'signup'
             },
             controllers: {
               sessions: 'users/sessions',
               registrations: 'users/registrations'
             }

  resources :users, only: [:index, :show]
  resources :posts, only: [:index, :create] do
      resources :comments, only: [:create]
      resources :likes, only: [:create, :destroy]
    end
  resources :invitations, only:[:create, :destroy, :update]
end
