class Api::V1::SupabaseController < ApplicationController
  
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
    # Return test data for now while we debug Supabase connection
    test_types = ['belt', 'roller', 'motor', 'sensor', 'controller', 'frame', 'accessory', 'chain', 'drive_unit']
    
    render json: {
      data: test_types,
      meta: {
        count: test_types.length,
        method: 'test_data',
        status: 'supabase_enabled'
      }
    }
  end

  def system_specifications
    # Return test data for now while we debug Supabase connection
    test_specifications = {
      'conveyor' => ['belt_conveyor', 'roller_conveyor', 'chain_conveyor'],
      'material_handling' => ['pallet_conveyor', 'overhead_conveyor', 'sorting_conveyor'],
      'packaging' => ['accumulation_conveyor', 'divert_conveyor', 'merge_conveyor']
    }
    
    render json: {
      data: test_specifications,
      meta: {
        categories: test_specifications.keys,
        total_types: test_specifications.values.flatten.uniq.length,
        method: 'test_data',
        status: 'supabase_enabled'
      }
    }
  end

  private

  def supabase_service
    @supabase_service ||= SupabaseService.new
  end
end 