class System
  include ActiveModel::Model
  include ActiveModel::Attributes

  # Define attributes based on the new systems table schema
  attribute :id, :integer
  attribute :system_code, :string
  attribute :system_name, :string
  attribute :category, :string
  attribute :description, :string
  attribute :key_features, array: true, default: []
  attribute :applications, array: true, default: []
  attribute :advantages, array: true, default: []
  attribute :technical_specs, :string, default: '{}'
  attribute :materials, array: true, default: []
  attribute :load_capacity, :string
  attribute :speed_range, :string
  attribute :precision_level, :string
  attribute :chain_pitch, :string
  attribute :chain_width, :string
  attribute :max_load, :string
  attribute :temperature_range, :string
  attribute :page_reference, :integer
  attribute :created_at, :datetime
  attribute :updated_at, :datetime

  # Validations
  validates :system_code, presence: true, length: { maximum: 10 }
  validates :system_name, presence: true, length: { maximum: 255 }
  validates :category, length: { maximum: 100 }
  validates :load_capacity, length: { maximum: 50 }
  validates :speed_range, length: { maximum: 50 }
  validates :precision_level, length: { maximum: 20 }
  validates :chain_pitch, length: { maximum: 20 }
  validates :chain_width, length: { maximum: 50 }
  validates :max_load, length: { maximum: 100 }
  validates :temperature_range, length: { maximum: 50 }

  # Scopes and class methods
  def self.find_by_system_code(system_code)
    supabase_service = SupabaseService.new
    system_data = supabase_service.get_system(system_code)
    return nil unless system_data

    new(system_data)
  end

  def self.all(filters = {})
    supabase_service = SupabaseService.new
    systems_data = supabase_service.get_systems(filters)
    systems_data.map { |data| new(data) }
  end

  def self.search(query, filters = {})
    supabase_service = SupabaseService.new
    systems_data = supabase_service.search_systems(query, filters)
    systems_data.map { |data| new(data) }
  end

  def self.by_category(category)
    supabase_service = SupabaseService.new
    systems_data = supabase_service.get_systems_by_category(category)
    systems_data.map { |data| new(data) }
  end

  def self.by_load_capacity(load_capacity)
    supabase_service = SupabaseService.new
    systems_data = supabase_service.get_systems_by_load_capacity(load_capacity)
    systems_data.map { |data| new(data) }
  end

  def self.stats
    supabase_service = SupabaseService.new
    supabase_service.get_system_stats
  end

  def self.overview
    supabase_service = SupabaseService.new
    overview_data = supabase_service.get_cached_system_overview
    overview_data.map { |data| new(data) }
  end

  # Instance methods
  def components(filters = {})
    supabase_service = SupabaseService.new
    components_data = supabase_service.get_components_by_system(system_code, filters)
    components_data.map { |data| Component.new(data) }
  end

  def compatible_components
    supabase_service = SupabaseService.new
    components_data = supabase_service.get_compatible_components(system_code)
    components_data.map { |data| Component.new(data) }
  end

  def images
    supabase_service = SupabaseService.new
    supabase_service.get_images_by_system(system_code)
  end

  def full_details
    supabase_service = SupabaseService.new
    details = supabase_service.get_system_with_components(system_code)
    return nil unless details

    {
      system: self,
      components: details[:components].map { |data| Component.new(data) },
      images: details[:images]
    }
  end

  def light_duty?
    load_capacity&.downcase&.include?('light')
  end

  def medium_duty?
    load_capacity&.downcase&.include?('medium')
  end

  def heavy_duty?
    load_capacity&.downcase&.include?('heavy')
  end

  def chain_system?
    category&.downcase&.include?('chain')
  end

  def belt_system?
    category&.downcase&.include?('belt')
  end

  def pallet_system?
    category&.downcase&.include?('pallet')
  end

  def technical_specifications
    JSON.parse(technical_specs || '{}')
  rescue JSON::ParserError
    {}
  end

  def has_images?
    images.any?
  end

  def has_components?
    components.any?
  end

  def to_param
    system_code
  end

  def to_s
    system_name
  end

  def display_name
    "#{system_code} - #{system_name}"
  end

  def summary
    {
      system_code: system_code,
      system_name: system_name,
      category: category,
      load_capacity: load_capacity,
      speed_range: speed_range,
      components_count: components.count,
      images_count: images.count
    }
  end
end
