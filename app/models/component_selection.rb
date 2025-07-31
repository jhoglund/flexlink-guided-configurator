class ComponentSelection < ApplicationRecord
  belongs_to :configuration

  # Validations
  validates :component_type, presence: true
  validates :component_id, presence: true
  validates :quantity, numericality: { greater_than: 0 }
  validates :price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :status, inclusion: { in: %w[selected pending rejected] }
  validates :system_code, length: { maximum: 10 }, allow_nil: true

  # Scopes
  scope :selected, -> { where(status: 'selected') }
  scope :by_type, ->(type) { where(component_type: type) }
  scope :by_system, ->(system_code) { where(system_code: system_code) }
  scope :active, -> { where(status: %w[selected pending]) }

  # Status methods
  def selected?
    status == 'selected'
  end

  def pending?
    status == 'pending'
  end

  def rejected?
    status == 'rejected'
  end

  # Price calculations
  def total_price
    return 0 if price.nil?

    price * quantity
  end

  def price_with_currency
    return 'N/A' if price.nil?

    "#{currency} #{price}"
  end

  def total_price_with_currency
    return 'N/A' if price.nil?

    "#{currency} #{total_price}"
  end

  # Component information
  def component_name_or_id
    component_name.presence || component_id
  end

  def specifications_summary
    return 'No specifications' if specifications.empty?

    specifications.map { |k, v| "#{k}: #{v}" }.join(', ')
  end

  def options_summary
    return 'No options' if options.empty?

    options.map { |k, v| "#{k}: #{v}" }.join(', ')
  end

  # System and Component relationships
  def system
    return nil unless system_code

    System.find_by_system_code(system_code)
  end

  def component
    return nil unless component_id

    Component.find(component_id)
  end

  def system_name
    system&.system_name || 'Unknown System'
  end

  def component_details
    component&.detailed_info || {}
  end

  def system_summary
    system&.summary || {}
  end

  # Selection methods
  def select!
    update!(
      status: 'selected',
      selected_at: Time.current
    )
  end

  def reject!
    update!(status: 'rejected')
  end

  def mark_pending!
    update!(status: 'pending')
  end

  # Export methods
  def to_export_hash
    {
      component_type: component_type,
      component_id: component_id,
      component_name: component_name,
      system_code: system_code,
      system_name: system_name,
      specifications: specifications,
      options: options,
      price: price,
      currency: currency,
      quantity: quantity,
      total_price: total_price,
      notes: notes,
      status: status,
      selected_at: selected_at,
      component_details: component_details,
      system_summary: system_summary
    }
  end

  # Factory methods for creating from System/Component data
  def self.create_from_component(component, configuration, quantity: 1, notes: nil)
    create!(
      configuration: configuration,
      component_type: component.component_type,
      component_id: component.id.to_s,
      component_name: component.name,
      system_code: component.system_code,
      specifications: component.specifications,
      price: component.price,
      currency: component.currency,
      quantity: quantity,
      notes: notes,
      status: 'selected',
      selected_at: Time.current
    )
  end

  def self.create_from_system_components(system, configuration, component_types: nil)
    components = system.components
    components = components.select { |c| component_types.include?(c.component_type) } if component_types

    components.map do |component|
      create_from_component(component, configuration)
    end
  end
end
