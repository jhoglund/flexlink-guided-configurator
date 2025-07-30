class ProductsController < ApplicationController
  before_action :set_product, only: [:show]

  def index
    @products = load_products
    @categories = get_product_categories
    @types = get_product_types
    @total_count = @products.count
    
    respond_to do |format|
      format.html
      format.json { render json: { products: @products, meta: { total: @total_count } } }
    end
  end

  def show
    @related_products = find_related_products(@product)
    
    respond_to do |format|
      format.html
      format.json { render json: { product: @product, related: @related_products } }
    end
  end

  def search
    query = params[:q]&.strip
    category = params[:category]
    product_type = params[:type]
    
    @products = search_products(query, category, product_type)
    @total_count = @products.count
    
    respond_to do |format|
      format.html { render :index }
      format.json { render json: { products: @products, meta: { total: @total_count, query: query } } }
    end
  end

  def by_category
    @category = params[:category]
    @products = get_products_by_category(@category)
    @total_count = @products.count
    
    respond_to do |format|
      format.html { render :index }
      format.json { render json: { products: @products, meta: { total: @total_count, category: @category } } }
    end
  end

  def by_type
    @type = params[:type]
    @products = get_products_by_type(@type)
    @total_count = @products.count
    
    respond_to do |format|
      format.html { render :index }
      format.json { render json: { products: @products, meta: { total: @total_count, type: @type } } }
    end
  end

  private

  def set_product
    @product = find_product_by_id(params[:id])
    unless @product
      redirect_to products_path, alert: "Product not found."
    end
  end

  def load_products
    # Load all available products from different sources
    products = []
    
    # Add system specifications as products
    products += get_system_specifications_products
    
    # Add component specifications as products
    products += get_component_specifications_products
    
    # Add fallback products if no data from Supabase
    if products.empty?
      products = get_fallback_products
    end
    
    # Apply sorting and pagination
    sort_products(products, params[:sort], params[:order])
  end

  def get_system_specifications_products
    begin
      supabase_service = SupabaseService.new
      systems = supabase_service.get_conveyor_systems
      
      systems.map do |system|
        {
          id: "system_#{system['id']}",
          name: system['name'],
          description: system['description'],
          category: 'Conveyor Systems',
          type: 'conveyor_system',
          price: nil, # Price not available in conveyor_systems table
          specifications: system['features'] || [],
          brand: 'FlexLink',
          image_url: system['image_url'],
          source: 'supabase'
        }
      end
    rescue => e
      Rails.logger.error "Failed to load system specifications: #{e.message}"
      []
    end
  end

  def get_component_specifications_products
    begin
      supabase_service = SupabaseService.new
      components = supabase_service.get_component_specifications
      
      components.map do |component|
        {
          id: "component_#{component['id']}",
          name: component['name'],
          description: component['description'],
          category: 'Component Specifications',
          type: component['component_type'],
          price: component['price_euro'], # Use price_euro from the schema
          specifications: component['specifications'] || [],
          brand: 'FlexLink',
          image_url: component['image_url'],
          source: 'supabase'
        }
      end
    rescue => e
      Rails.logger.error "Failed to load component specifications: #{e.message}"
      []
    end
  end

  def get_fallback_products
    # Fallback products when Supabase is not available
    [
      {
        id: 'belt_conveyor_1',
        name: 'Standard Belt Conveyor',
        description: 'High-quality belt conveyor system for general material handling',
        category: 'Belt Conveyors',
        type: 'belt_conveyor',
        price: 2500.00,
        specifications: ['Length: 10m', 'Width: 0.5m', 'Speed: 0.5 m/s', 'Material: Steel'],
        brand: 'FlexLink',
        image_url: nil,
        source: 'fallback'
      },
      {
        id: 'roller_conveyor_1',
        name: 'Powered Roller Conveyor',
        description: 'Efficient powered roller system for heavy-duty applications',
        category: 'Roller Conveyors',
        type: 'roller_conveyor',
        price: 3200.00,
        specifications: ['Length: 15m', 'Width: 0.6m', 'Speed: 0.8 m/s', 'Material: Stainless Steel'],
        brand: 'FlexLink',
        image_url: nil,
        source: 'fallback'
      },
      {
        id: 'screw_conveyor_1',
        name: 'Screw Conveyor System',
        description: 'Specialized screw-based system for bulk material handling',
        category: 'Specialty Conveyors',
        type: 'screw_conveyor',
        price: 4500.00,
        specifications: ['Length: 8m', 'Diameter: 0.3m', 'Capacity: 50 tons/hour', 'Material: Carbon Steel'],
        brand: 'FlexLink',
        image_url: nil,
        source: 'fallback'
      },
      {
        id: 'motor_1',
        name: 'High-Efficiency Motor',
        description: 'Premium motor for conveyor drive systems',
        category: 'Components',
        type: 'motor',
        price: 450.00,
        specifications: ['Power: 5.5 kW', 'Speed: 1440 RPM', 'Efficiency: 95%', 'Protection: IP55'],
        brand: 'FlexLink',
        image_url: nil,
        source: 'fallback'
      },
      {
        id: 'sensor_1',
        name: 'Proximity Sensor',
        description: 'Reliable sensor for position detection and safety',
        category: 'Components',
        type: 'sensor',
        price: 85.00,
        specifications: ['Range: 8mm', 'Voltage: 24V DC', 'Output: PNP', 'Protection: IP67'],
        brand: 'FlexLink',
        image_url: nil,
        source: 'fallback'
      },
      {
        id: 'controller_1',
        name: 'PLC Controller',
        description: 'Advanced programmable logic controller for automation',
        category: 'Components',
        type: 'controller',
        price: 650.00,
        specifications: ['CPU: 32-bit', 'Memory: 64MB', 'I/O: 24 digital, 8 analog', 'Protocol: Modbus'],
        brand: 'FlexLink',
        image_url: nil,
        source: 'fallback'
      }
    ]
  end

  def search_products(query, category, product_type)
    products = load_products
    
    # Filter by query
    if query.present?
      products = products.select do |product|
        product[:name].downcase.include?(query.downcase) ||
        product[:description].downcase.include?(query.downcase) ||
        product[:category].downcase.include?(query.downcase) ||
        product[:type].downcase.include?(query.downcase)
      end
    end
    
    # Filter by category
    if category.present?
      products = products.select { |product| product[:category].downcase == category.downcase }
    end
    
    # Filter by type
    if product_type.present?
      products = products.select { |product| product[:type].downcase == product_type.downcase }
    end
    
    sort_products(products, params[:sort], params[:order])
  end

  def get_products_by_category(category)
    products = load_products
    products.select { |product| product[:category].downcase == category.downcase }
  end

  def get_products_by_type(type)
    products = load_products
    products.select { |product| product[:type].downcase == type.downcase }
  end

  def find_product_by_id(id)
    products = load_products
    products.find { |product| product[:id] == id }
  end

  def find_related_products(product)
    products = load_products
    products.select do |p|
      p[:id] != product[:id] && 
      (p[:category] == product[:category] || p[:type] == product[:type])
    end.first(4)
  end

  def get_product_categories
    products = load_products
    products.map { |p| p[:category] }.uniq.sort
  end

  def get_product_types
    products = load_products
    products.map { |p| p[:type] }.uniq.sort
  end

  def sort_products(products, sort_by = 'name', order = 'asc')
    case sort_by
    when 'price'
      products.sort_by! { |p| p[:price] || 0 }
    when 'category'
      products.sort_by! { |p| p[:category] }
    when 'type'
      products.sort_by! { |p| p[:type] }
    else
      products.sort_by! { |p| p[:name] }
    end
    
    products.reverse! if order == 'desc'
    products
  end
end 