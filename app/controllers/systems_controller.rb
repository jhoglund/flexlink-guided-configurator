class SystemsController < ApplicationController
  before_action :set_system, only: %i[show components images details]

  def index
    Rails.logger.info '=== Systems#index called ==='

    begin
      # Try to load systems from Supabase
      Rails.logger.info 'Loading systems from Supabase...'
      @systems = load_systems
      @categories = get_system_categories
      @load_capacities = get_load_capacities
      @total_count = @systems.count
      @systems_by_category = @systems.group_by(&:category)

      Rails.logger.info "Loaded #{@systems.count} systems from Supabase"
      Rails.logger.info "Categories: #{@categories}"
      Rails.logger.info "Load capacities: #{@load_capacities}"

      respond_to do |format|
        format.html
        format.json { render json: { systems: @systems, meta: { total: @total_count } } }
      end
    rescue StandardError => e
      Rails.logger.error "Error loading systems from Supabase: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")

      # Fallback to demo systems
      Rails.logger.info 'Falling back to demo systems'
      @systems = get_fallback_systems
      @categories = ['Chain Conveyor']
      @load_capacities = ['Light duty', 'Medium', 'Medium duty']
      @total_count = @systems.count
      @systems_by_category = @systems.group_by(&:category)

      respond_to do |format|
        format.html
        format.json { render json: { systems: @systems, meta: { total: @total_count } } }
      end
    end
  end

  def show
    # Use fallback related systems to avoid Supabase connection issues
    @related_systems = get_fallback_systems.select do |s|
      s.system_code != @system.system_code &&
        (s.category == @system.category || s.load_capacity == @system.load_capacity)
    end.first(4)

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

    # Use fallback components for now to avoid Supabase connection issues
    @components = get_fallback_components(filters)

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

    # Use fallback systems for now to avoid Supabase connection issues
    fallback_systems = get_fallback_systems
    @system = fallback_systems.find { |s| s.system_code == system_code }

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
      System.new(
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
        technical_specs: { 'chain_pitch' => '45mm', 'chain_width' => '45mm' }.to_json
      ),
      System.new(
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
        technical_specs: { 'chain_pitch' => '65mm', 'chain_width' => '65mm' }.to_json
      ),
      System.new(
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
        technical_specs: { 'chain_pitch' => '85mm', 'chain_width' => '85mm' }.to_json
      )
    ]
  end

  def get_fallback_components(filters = {})
    # Fallback components when Supabase is not available
    components = [
      Component.new(
        id: 1,
        system_code: 'X45',
        component_type: 'chain',
        name: 'X45 Chain Link',
        description: 'High-quality chain link for X45 conveyor systems',
        manufacturer: 'FlexLink',
        part_number: 'XL-45-001',
        price: 12.50,
        currency: 'USD',
        material: 'Stainless Steel',
        color: 'Silver',
        weight: 0.25,
        specifications: { 'pitch' => '45mm', 'width' => '45mm', 'tensile_strength' => '2000N' }.to_json,
        compatibility: ['X45']
      ),
      Component.new(
        id: 2,
        system_code: 'X45',
        component_type: 'drive',
        name: 'X45 Drive Unit',
        description: 'Compact drive unit for X45 chain conveyors',
        manufacturer: 'FlexLink',
        part_number: 'XD-45-001',
        price: 450.00,
        currency: 'USD',
        material: 'Aluminium',
        color: 'Gray',
        weight: 8.5,
        specifications: { 'power' => '0.37kW', 'speed' => '20m/min', 'voltage' => '230V' }.to_json,
        compatibility: ['X45']
      ),
      Component.new(
        id: 3,
        system_code: 'X45',
        component_type: 'motor',
        name: 'X45 Motor Assembly',
        description: 'High-efficiency motor for X45 systems',
        manufacturer: 'FlexLink',
        part_number: 'XM-45-001',
        price: 320.00,
        currency: 'USD',
        material: 'Steel',
        color: 'Black',
        weight: 12.0,
        specifications: { 'power' => '0.37kW', 'rpm' => '1400', 'efficiency' => '85%' }.to_json,
        compatibility: ['X45']
      ),
      Component.new(
        id: 4,
        system_code: 'X45',
        component_type: 'sensor',
        name: 'X45 Proximity Sensor',
        description: 'Reliable proximity sensor for position detection',
        manufacturer: 'FlexLink',
        part_number: 'XS-45-001',
        price: 85.00,
        currency: 'USD',
        material: 'Plastic',
        color: 'Blue',
        weight: 0.15,
        specifications: { 'range' => '8mm', 'voltage' => '24V', 'output' => 'PNP' }.to_json,
        compatibility: %w[X45 X65]
      ),
      Component.new(
        id: 5,
        system_code: 'X45',
        component_type: 'frame',
        name: 'X45 Frame Section',
        description: 'Modular frame section for X45 conveyors',
        manufacturer: 'FlexLink',
        part_number: 'XF-45-001',
        price: 180.00,
        currency: 'USD',
        material: 'Aluminium',
        color: 'Silver',
        weight: 5.2,
        specifications: { 'length' => '1000mm', 'width' => '200mm', 'height' => '150mm' }.to_json,
        compatibility: ['X45']
      ),
      Component.new(
        id: 6,
        system_code: 'X45',
        component_type: 'accessory',
        name: 'X45 Chain Lubricator',
        description: 'Automatic chain lubrication system',
        manufacturer: 'FlexLink',
        part_number: 'XA-45-001',
        price: 95.00,
        currency: 'USD',
        material: 'Plastic',
        color: 'White',
        weight: 0.8,
        specifications: { 'capacity' => '500ml', 'flow_rate' => '2ml/min', 'timer' => 'adjustable' }.to_json,
        compatibility: %w[X45 X65 X85]
      )
    ]

    # Apply filters
    if filters[:component_type].present?
      components = components.select { |c| c.component_type == filters[:component_type] }
    end

    if filters[:min_price].present?
      min_price = filters[:min_price].to_f
      components = components.select { |c| c.price && c.price >= min_price }
    end

    if filters[:max_price].present?
      max_price = filters[:max_price].to_f
      components = components.select { |c| c.price && c.price <= max_price }
    end

    components
  end
end
