class Api::V1::SupabaseController < ApplicationController
  skip_before_action :authenticate_user!
  
  def conveyor_systems
    filters = params.permit(:system_type, :system_category, :min_length, :max_length).to_h
    systems = supabase_service.get_conveyor_systems(filters)
    
    render json: {
      data: systems,
      meta: {
        count: systems.length,
        filters: filters
      }
    }
  end

  def component_specifications
    filters = params.permit(:component_type, :min_price, :max_price, :search).to_h
    components = supabase_service.get_component_specifications(filters)
    
    render json: {
      data: components,
      meta: {
        count: components.length,
        filters: filters
      }
    }
  end

  def search_components
    query = params[:q]
    filters = params.permit(:component_type, :min_price, :max_price).to_h
    
    if query.blank?
      render json: { error: 'Search query is required' }, status: :bad_request
      return
    end
    
    components = supabase_service.search_components(query, filters)
    
    render json: {
      data: components,
      meta: {
        query: query,
        count: components.length,
        filters: filters
      }
    }
  end

  def component_types
    types = supabase_service.get_component_types
    
    render json: {
      data: types,
      meta: {
        count: types.length
      }
    }
  end

  def system_specifications
    specifications = supabase_service.get_system_specifications
    
    render json: {
      data: specifications,
      meta: {
        categories: specifications.keys,
        total_types: specifications.values.flatten.uniq.length
      }
    }
  end
end 