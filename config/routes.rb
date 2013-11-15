SecretSauce::Application.routes.draw do

  get "interests/create"
  get "interests/destroy"
  match '/yummly_recipe', to: 'yummly_recipes#new', via: 'get'
  match '/password_reset', to: 'password_resets#new', via: 'get'
  
  match '/signup', to: 'users#new', via: 'get'
  match '/signin', to: 'sessions#new', via: 'get'
  match '/signout', to: 'sessions#destroy', via: 'delete'
  
  root 'secret_sauce_pages#home'
  match '/home', to: 'secret_sauce_pages#home', via: 'get'
  match '/secret_sauce_pages/home', to: 'secret_sauce_pages#home', via: 'get'
  
  match '/secret_sauce_pages/help', to: 'secret_sauce_pages#help', via: 'get'
  match '/help', to: 'secret_sauce_pages#help', via: 'get'
  
  match '/about', to: 'secret_sauce_pages#about', via: 'get'
  match '/contact', to: 'secret_sauce_pages#contact', via: 'get'
  
  resources :users do
    member do
    get :following, :followers
    end
  end
  resources :sessions, only: [:new, :create, :destroy]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :recipes, only: [:show, :new, :create, :edit, :update, :destroy]
  resources :platters, only: [:show, :create, :edit, :update, :destroy] do
    member do
    get :following, :followed
    end
  end
  resources :yummly_recipes, only: [:new, :index, :show]
  resources :relationships, only: [:create, :destroy]
  resources :selections, only: [:create, :destroy]
  resources :interests, only: [:create, :destroy]
  
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
