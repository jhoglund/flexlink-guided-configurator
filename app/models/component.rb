class Component
  include ActiveModel::Model
  include ActiveModel::Attributes

  # Define attributes based on the components table schema
  attribute :id, :integer
  attribute :system_code, :string
  attribute :component_type, :string
  attribute :name, :string
  attribute :specifications, :string, default: '{}'
  attribute :compatibility, array: true, default: []
  attribute :price, :decimal
  attribute :currency, :string, default: 'USD'
  attribute :description, :string
  attribute :manufacturer, :string
  attribute :part_number, :string
  attribute :dimensions, :string, default: '{}'
  attribute :weight, :decimal
  attribute :material, :string
  attribute :color, :string
  attribute :created_at, :datetime
  attribute :updated_at, :datetime

  # Validations
  validates :system_code, presence: true, length: { maximum: 10 }
  validates :component_type, presence: true, length: { maximum: 100 }
  validates :name, presence: true, length: { maximum: 255 }
  validates :price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :currency, length: { maximum: 3 }
  validates :manufacturer, length: { maximum: 255 }
  validates :part_number, length: { maximum: 100 }
  validates :material, length: { maximum: 100 }
  validates :color, length: { maximum: 50 }

  # Scopes and class methods
  def self.find(id)
    supabase_service = SupabaseService.new
    component_data = supabase_service.get_component(id)
    return nil unless component_data

    new(component_data)
  end

  def self.all(filters = {})
    supabase_service = SupabaseService.new
    components_data = supabase_service.get_components(filters)
    components_data.map { |data| new(data) }
  end

  def self.search(query, filters = {})
    supabase_service = SupabaseService.new
    components_data = supabase_service.search_components(query, filters)
    components_data.map { |data| new(data) }
  end

  def self.by_type(component_type, filters = {})
    supabase_service = SupabaseService.new
    components_data = supabase_service.get_components_by_type(component_type, filters)
    components_data.map { |data| new(data) }
  end

  def self.by_system(system_code, filters = {})
    supabase_service = SupabaseService.new
    components_data = supabase_service.get_components_by_system(system_code, filters)
    components_data.map { |data| new(data) }
  end

  def self.compatible_with(system_code)
    supabase_service = SupabaseService.new
    components_data = supabase_service.get_compatible_components(system_code)
    components_data.map { |data| new(data) }
  end

  def self.types
    supabase_service = SupabaseService.new
    supabase_service.get_component_types
  end

  def self.compatibility_matrix
    supabase_service = SupabaseService.new
    supabase_service.get_component_compatibility
  end

  # Instance methods
  def system
    return nil unless system_code

    System.find_by_system_code(system_code)
  end

  def compatible_systems
    return [] unless compatibility.any?

    compatibility.map { |system_code| System.find_by_system_code(system_code) }.compact
  end

  def price_formatted
    return 'N/A' unless price

    ActionController::Base.helpers.number_to_currency(price, unit: currency == 'USD' ? '$' : currency)
  end

  def weight_formatted
    return 'N/A' unless weight

    "#{weight} kg"
  end

  def dimensions_formatted
    return 'N/A' if dimensions.blank?

    begin
      dims = JSON.parse(dimensions)
      if dims['length'] && dims['width'] && dims['height']
        "#{dims['length']} × #{dims['width']} × #{dims['height']} mm"
      elsif dims['length'] && dims['width']
        "#{dims['length']} × #{dims['width']} mm"
      else
        'See specifications'
      end
    rescue JSON::ParserError
      'See specifications'
    end
  end

  def specifications_formatted
    return 'N/A' if specifications.blank?

    begin
      specs = JSON.parse(specifications)
      formatted = []

      specs.each do |key, value|
        next if value.blank?

        formatted << "#{key.humanize}: #{value}"
      end

      formatted.join(', ')
    rescue JSON::ParserError
      'N/A'
    end
  end

  def chain_component?
    component_type&.downcase&.include?('chain')
  end

  def drive_component?
    component_type&.downcase&.include?('drive')
  end

  def motor_component?
    component_type&.downcase&.include?('motor')
  end

  def sensor_component?
    component_type&.downcase&.include?('sensor')
  end

  def frame_component?
    component_type&.downcase&.include?('frame')
  end

  def accessory_component?
    component_type&.downcase&.include?('accessory')
  end

  def belt_component?
    component_type&.downcase&.include?('belt')
  end

  def roller_component?
    component_type&.downcase&.include?('roller')
  end

  def controller_component?
    component_type&.downcase&.include?('controller')
  end

  def has_price?
    price.present? && price > 0
  end

  def has_specifications?
    specifications.present? && specifications != '{}'
  end

  def has_dimensions?
    dimensions.present? && dimensions != '{}'
  end

  def has_weight?
    weight.present? && weight > 0
  end

  def to_param
    id.to_s
  end

  def to_s
    name
  end

  def display_name
    if part_number.present?
      "#{name} (#{part_number})"
    else
      name
    end
  end

  def summary
    {
      id: id,
      name: name,
      component_type: component_type,
      system_code: system_code,
      price: price_formatted,
      manufacturer: manufacturer,
      part_number: part_number,
      has_specifications: has_specifications?,
      has_dimensions: has_dimensions?,
      has_weight: has_weight?
    }
  end

  def detailed_info
    {
      id: id,
      name: name,
      component_type: component_type,
      system_code: system_code,
      description: description,
      price: price_formatted,
      manufacturer: manufacturer,
      part_number: part_number,
      dimensions: dimensions_formatted,
      weight: weight_formatted,
      material: material,
      color: color,
      specifications: specifications_formatted,
      compatibility: compatibility,
      created_at: created_at,
      updated_at: updated_at
    }
  end
end
