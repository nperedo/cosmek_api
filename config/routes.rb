Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do 
      resources :customers, only: [:index, :show, :create]

      resources :stylists, only: [:index, :show, :create] do 
        member do 
          get :availability
        end
      end

      resources :appointments, only: [:index, :show, :create] do 
        member do 
          post :cancel
          post :reschedule
        end
      end
    end 
  end 
end
