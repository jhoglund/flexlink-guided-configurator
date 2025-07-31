class Api::V1::SupabaseController < ApplicationController
  # Systems endpoints (NEW)
  def systems
    filters = params.permit(:category, :load_capacity, :system_code, :search).to_h
    systems = supabase_service.get_systems(filters)

    render json: {
      data: systems,
      meta: {
        count: systems.length,
        filters: filters
      }
    }
  end

  def system
    system_code = params[:system_code]
    system = supabase_service.get_system(system_code)

    if system
      render json: {
        data: system,
        meta: {
          system_code: system_code
        }
      }
    else
      render json: { error: 'System not found' }, status: :not_found
    end
  end

  def search_systems
    query = params[:q]
    filters = params.permit(:category, :load_capacity).to_h

    if query.blank?
      render json: { error: 'Search query is required' }, status: :bad_request
      return
    end

    systems = supabase_service.search_systems(query, filters)

    render json: {
      data: systems,
      meta: {
        query: query,
        count: systems.length,
        filters: filters
      }
    }
  end

  def system_stats
    stats = supabase_service.get_system_stats

    render json: {
      data: stats,
      meta: {
        generated_at: Time.current
      }
    }
  end

  def system_overview
    overview = supabase_service.get_cached_system_overview

    render json: {
      data: overview,
      meta: {
        count: overview.length,
        cached: true
      }
    }
  end

  # Components endpoints (UPDATED)
  def components
    filters = params.permit(:component_type, :system_code, :min_price, :max_price, :search).to_h
    components = supabase_service.get_components(filters)

    render json: {
      data: components,
      meta: {
        count: components.length,
        filters: filters
      }
    }
  end

  def component
    id = params[:id]
    component = supabase_service.get_component(id)

    if component
      render json: {
        data: component,
        meta: {
          id: id
        }
      }
    else
      render json: { error: 'Component not found' }, status: :not_found
    end
  end

  def search_components
    query = params[:q]
    filters = params.permit(:component_type, :system_code, :min_price, :max_price).to_h

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

  def components_by_system
    system_code = params[:system_code]
    filters = params.permit(:component_type, :min_price, :max_price).to_h

    components = supabase_service.get_components_by_system(system_code, filters)

    render json: {
      data: components,
      meta: {
        system_code: system_code,
        count: components.length,
        filters: filters
      }
    }
  end

  def component_compatibility
    compatibility = supabase_service.get_component_compatibility

    render json: {
      data: compatibility,
      meta: {
        count: compatibility.length
      }
    }
  end

  # Product Images endpoints
  def product_images
    filters = params.permit(:system_code, :image_type).to_h
    images = supabase_service.get_product_images(filters)

    render json: {
      data: images,
      meta: {
        count: images.length,
        filters: filters
      }
    }
  end

  def images_by_system
    system_code = params[:system_code]
    images = supabase_service.get_images_by_system(system_code)

    render json: {
      data: images,
      meta: {
        system_code: system_code,
        count: images.length
      }
    }
  end

  # System with full details
  def system_details
    system_code = params[:system_code]
    details = supabase_service.get_system_with_components(system_code)

    if details
      render json: {
        data: details,
        meta: {
          system_code: system_code,
          components_count: details[:components].length,
          images_count: details[:images].length
        }
      }
    else
      render json: { error: 'System not found' }, status: :not_found
    end
  end

  # Legacy endpoints for backward compatibility
  def conveyor_systems
    filters = params.permit(:system_type, :system_category, :min_length, :max_length).to_h
    systems = supabase_service.get_conveyor_systems(filters)

    render json: {
      data: systems,
      meta: {
        count: systems.length,
        filters: filters,
        deprecated: true,
        message: 'Use /api/v1/systems instead'
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
        filters: filters,
        deprecated: true,
        message: 'Use /api/v1/components instead'
      }
    }
  end

  def component_types
    # Return test data for now while we debug Supabase connection
    test_types = %w[belt roller motor sensor controller frame accessory chain drive_unit]

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
      'conveyor' => %w[belt_conveyor roller_conveyor chain_conveyor],
      'material_handling' => %w[pallet_conveyor overhead_conveyor sorting_conveyor],
      'packaging' => %w[accumulation_conveyor divert_conveyor merge_conveyor]
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
