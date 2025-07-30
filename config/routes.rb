Rails.application.routes.draw do
  # Devise routes for authentication
  devise_for :users
  
  # Root route
  root 'home#index'
  
  # Dashboard
  get 'dashboard', to: 'home#dashboard'
  
  # Wizard routes for guided configuration
  namespace :wizard do
    get 'step/:step', to: 'steps#show', as: :step
    patch 'step/:step', to: 'steps#update', as: :update_step
    get 'summary', to: 'steps#summary', as: :summary
    post 'complete', to: 'steps#complete', as: :complete
    delete 'reset', to: 'steps#reset', as: :reset
  end
  
  # Configuration management
  resources :configurations do
    member do
      get 'export'
      get 'duplicate'
      patch 'status'
    end
    collection do
      get 'templates'
      post 'from_template'
    end
  end
  
  # API routes for Supabase integration
  namespace :api do
    namespace :v1 do
      get 'conveyor_systems', to: 'supabase#conveyor_systems'
      get 'component_specifications', to: 'supabase#component_specifications'
      get 'component_specifications/search', to: 'supabase#search_components'
      get 'component_types', to: 'supabase#component_types'
      get 'system_specifications', to: 'supabase#system_specifications'
    end
  end
  
  # Health check
  get 'health', to: 'health#index'
end 