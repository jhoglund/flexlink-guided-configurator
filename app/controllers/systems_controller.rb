class SystemsController < ApplicationController
  before_action :set_system, only: %i[show components images details]

  def index
    @systems = load_systems
    @categories = get_system_categories
    @load_capacities = get_load_capacities
    @total_count = @systems.count

    respond_to do |format|
      format.html
      format.json { render json: { systems: @systems, meta: { total: @total_count } } }
    end
  end

  def show
    @related_systems = find_related_systems(@system)

    respond_to do |format|
      format.html
      format.json { render json: { system: @system, related: @related_systems } }
    end
  end

  def search
    query = params[:q]&.strip
    category = params[:category]
    load_capacity = params[:load_capacity]

    @systems = search_systems(query, category, load_capacity)
    @categories = get_system_categories
    @load_capacities = get_load_capacities
    @total_count = @systems.count

    respond_to do |format|
      format.html { render :index }
      format.json { render json: { systems: @systems, meta: { total: @total_count, query: query } } }
    end
  end

  def by_category
    @category = params[:category]
    @systems = get_systems_by_category(@category)
    @categories = get_system_categories
    @load_capacities = get_load_capacities
    @total_count = @systems.count

    respond_to do |format|
      format.html { render :index }
      format.json { render json: { systems: @systems, meta: { total: @total_count, category: @category } } }
    end
  end

  def by_load_capacity
    @load_capacity = params[:load_capacity]
    @systems = get_systems_by_load_capacity(@load_capacity)
    @categories = get_system_categories
    @load_capacities = get_load_capacities
    @total_count = @systems.count

    respond_to do |format|
      format.html { render :index }
      format.json { render json: { systems: @systems, meta: { total: @total_count, load_capacity: @load_capacity } } }
    end
  end

  def components
    filters = params.permit(:component_type, :min_price, :max_price).to_h
    @components = @system.components(filters)

    respond_to do |format|
      format.html
      format.json do
        render json: { components: @components, meta: { system_code: @system.system_code, count: @components.count } }
      end
    end
  end

  def images
    @images = @system.images

    respond_to do |format|
      format.html
      format.json { render json: { images: @images, meta: { system_code: @system.system_code, count: @images.count } } }
    end
  end

  def details
    @details = @system.full_details

    if @details
      respond_to do |format|
        format.html
        format.json { render json: { details: @details, meta: { system_code: @system.system_code } } }
      end
    else
      respond_to do |format|
        format.html { redirect_to system_path(@system), alert: 'System details not found.' }
        format.json { render json: { error: 'System details not found' }, status: :not_found }
      end
    end
  end

  def stats
    @stats = System.stats

    respond_to do |format|
      format.html
      format.json { render json: { stats: @stats } }
    end
  end

  def overview
    @overview = System.overview

    respond_to do |format|
      format.html
      format.json { render json: { overview: @overview, meta: { count: @overview.count } } }
    end
  end

  private

  def set_system
    system_code = params[:system_code] || params[:id]
    @system = System.find_by_system_code(system_code)
    return if @system

    redirect_to systems_path, alert: 'System not found.'
  end

  def load_systems
    filters = params.permit(:category, :load_capacity, :system_code).to_h
    System.all(filters)
  rescue StandardError => e
    Rails.logger.error "Failed to load systems: #{e.message}"
    get_fallback_systems
  end

  def search_systems(query, category, load_capacity)
    filters = {}
    filters[:category] = category if category.present?
    filters[:load_capacity] = load_capacity if load_capacity.present?

    if query.present?
      System.search(query, filters)
    else
      System.all(filters)
    end
  rescue StandardError => e
    Rails.logger.error "Failed to search systems: #{e.message}"
    get_fallback_systems
  end

  def get_systems_by_category(category)
    System.by_category(category)
  rescue StandardError => e
    Rails.logger.error "Failed to get systems by category: #{e.message}"
    get_fallback_systems
  end

  def get_systems_by_load_capacity(load_capacity)
    System.by_load_capacity(load_capacity)
  rescue StandardError => e
    Rails.logger.error "Failed to get systems by load capacity: #{e.message}"
    get_fallback_systems
  end

  def find_system_by_system_code(system_code)
    System.find_by_system_code(system_code)
  end

  def find_related_systems(system)
    systems = load_systems
    systems.select do |s|
      s.system_code != system.system_code &&
        (s.category == system.category || s.load_capacity == system.load_capacity)
    end.first(4)
  end

  def get_system_categories
    systems = load_systems
    systems.map { |s| s.category }.compact.uniq.sort
  end

  def get_load_capacities
    systems = load_systems
    systems.map { |s| s.load_capacity }.compact.uniq.sort
  end

  def get_fallback_systems
    # Fallback systems when Supabase is not available
    [
      OpenStruct.new(
        system_code: 'X45',
        system_name: 'X45 Chain System',
        category: 'Chain Conveyor',
        description: 'Compact chain conveyor system for space-constrained applications',
        load_capacity: 'Light duty',
        speed_range: 'Up to 20 m/min',
        precision_level: 'Standard',
        key_features: ['Compact design', 'Space efficient', 'Easy installation'],
        applications: %w[Packaging Assembly Sorting],
        advantages: ['Low maintenance', 'High reliability', 'Cost effective'],
        materials: ['Aluminium', 'Stainless steel'],
        technical_specs: { 'chain_pitch' => '45mm', 'chain_width' => '45mm' }
      ),
      OpenStruct.new(
        system_code: 'X65',
        system_name: 'X65 Chain System',
        category: 'Chain Conveyor',
        description: 'Standard chain conveyor for versatile applications',
        load_capacity: 'Medium',
        speed_range: 'Up to 30 m/min',
        precision_level: 'Standard',
        key_features: ['Versatile design', 'High capacity', 'Modular construction'],
        applications: ['Material handling', 'Production lines', 'Warehousing'],
        advantages: ['Flexible configuration', 'High throughput', 'Easy maintenance'],
        materials: ['Aluminium', 'Carbon steel'],
        technical_specs: { 'chain_pitch' => '65mm', 'chain_width' => '65mm' }
      ),
      OpenStruct.new(
        system_code: 'X85',
        system_name: 'X85 Chain System',
        category: 'Chain Conveyor',
        description: 'Medium-duty chain conveyor for demanding applications',
        load_capacity: 'Medium duty',
        speed_range: 'Up to 40 m/min',
        precision_level: 'High',
        key_features: ['Heavy duty', 'High precision', 'Robust construction'],
        applications: ['Heavy industry', 'Automotive', 'Manufacturing'],
        advantages: ['High load capacity', 'Precision positioning', 'Long service life'],
        materials: ['Carbon steel', 'Hardened steel'],
        technical_specs: { 'chain_pitch' => '85mm', 'chain_width' => '85mm' }
      )
    ]
  end
end
