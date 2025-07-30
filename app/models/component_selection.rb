class ComponentSelection < ApplicationRecord
  belongs_to :configuration

  # Validations
  validates :component_type, presence: true
  validates :component_id, presence: true
  validates :quantity, numericality: { greater_than: 0 }
  validates :price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :status, inclusion: { in: %w[selected pending rejected] }

  # Scopes
  scope :selected, -> { where(status: 'selected') }
  scope :by_type, ->(type) { where(component_type: type) }
  scope :active, -> { where(status: ['selected', 'pending']) }

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
      specifications: specifications,
      options: options,
      price: price,
      currency: currency,
      quantity: quantity,
      total_price: total_price,
      notes: notes,
      status: status,
      selected_at: selected_at
    }
  end
end 