Rails.application.routes.draw do
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

  # Systems management
  resources :systems, only: %i[index show] do
    member do
      get 'components'
      get 'images'
      get 'details'
    end
    collection do
      get 'search'
      get 'by_category/:category', to: 'systems#by_category', as: :by_category
      get 'by_load_capacity/:load_capacity', to: 'systems#by_load_capacity', as: :by_load_capacity
      get 'stats'
      get 'overview'
    end
  end

  # Product data management
  resources :products, only: %i[index show] do
    collection do
      get 'search'
      get 'by_category/:category', to: 'products#by_category', as: :by_category
      get 'by_type/:type', to: 'products#by_type', as: :by_type
    end
  end

  # API routes for Supabase integration
  namespace :api do
    namespace :v1 do
      # New Systems endpoints
      get 'systems', to: 'supabase#systems'
      get 'systems/search', to: 'supabase#search_systems'
      get 'systems/stats', to: 'supabase#system_stats'
      get 'systems/overview', to: 'supabase#system_overview'
      get 'systems/:system_code', to: 'supabase#system'
      get 'systems/:system_code/details', to: 'supabase#system_details'
      get 'systems/:system_code/components', to: 'supabase#components_by_system'
      get 'systems/:system_code/images', to: 'supabase#images_by_system'

      # New Components endpoints
      get 'components', to: 'supabase#components'
      get 'components/search', to: 'supabase#search_components'
      get 'components/compatibility', to: 'supabase#component_compatibility'
      get 'components/:id', to: 'supabase#component'

      # Product Images endpoints
      get 'product_images', to: 'supabase#product_images'

      # Legacy endpoints for backward compatibility
      get 'conveyor_systems', to: 'supabase#conveyor_systems'
      get 'component_specifications', to: 'supabase#component_specifications'
      get 'component_specifications/search', to: 'supabase#search_components'
      get 'component_types', to: 'supabase#component_types'
      get 'system_specifications', to: 'supabase#system_specifications'
    end
  end

  # Health check
  get 'health', to: 'health#index'

  # Dev-only routes
  if Rails.env.development?
    get 'grid_test', to: 'dev#grid'
  end
end
