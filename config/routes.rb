Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api do
    resources :products do
      collection do
        get 'search'
        get 'approval_queue'
      end
      member do
        put 'approve'
        put 'reject'
      end
    end
  end
end
