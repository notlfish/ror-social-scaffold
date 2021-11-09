Rails.application.routes.draw do
  root 'posts#index'

  namespace :api,  defaults: {format: 'json'} do
    namespace :v1 do
      resources :users, only: [:index, :show] do
        resources :posts, only: [:index, :show, :create] do
          resources :comments, only: [:index, :show, :create]
        end
      end
    end
  end

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
